package com.homilabs.phonemanager

import android.app.Activity
import android.app.ActivityManager
import android.app.usage.StorageStatsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.PermissionInfo
import android.os.BatteryManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.os.Process
import android.os.storage.StorageManager
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/**
 * Phone-wide readings (channel `com.homilabs.phonemanager/device`): storage, battery, memory,
 * recent app use and which apps hold which runtime permissions.
 *
 * What Android lets a normal app do here: read all of these (storage breakdown and app use need
 * Usage access), clear its own cache, and on Android 13 and older ask the system to stop other
 * apps' background processes. Everything else opens the matching system screen.
 */
class DeviceChannel(
    private val activity: Activity,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, CHANNEL)
    private val worker: ExecutorService = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private val pm: PackageManager get() = activity.packageManager

    init {
        channel.setMethodCallHandler(this)
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        worker.shutdown()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "storage" -> background(result) { storage() }
            "battery" -> result.success(battery())
            "memory" -> result.success(memory())
            "canStopBackgroundApps" -> result.success(canStopBackgroundApps())
            "stopBackgroundApps" -> background(result) { stopBackgroundApps() }
            "recentUsage" -> background(result) { recentUsage() }
            "grantedPermissions" -> background(result) { grantedPermissions() }
            "ownCacheBytes" -> background(result) { ownCacheDirs().sumOf { sizeOf(it) } }
            "clearOwnCache" -> background(result) { clearOwnCache() }
            "openSystemScreen" -> result.success(openSystemScreen(call.argument<String>("screen")))
            else -> result.notImplemented()
        }
    }

    /** Total and free bytes; the breakdown by kind needs Usage access and is null without it. */
    private fun storage(): Map<String, Any?> {
        val stats = activity.getSystemService(StorageStatsManager::class.java)
        val uuid = StorageManager.UUID_DEFAULT
        val breakdown = try {
            val s = stats.queryExternalStatsForUser(uuid, Process.myUserHandle())
            mapOf(
                "images" to s.imageBytes,
                "videos" to s.videoBytes,
                "audio" to s.audioBytes,
                "files" to s.totalBytes - s.imageBytes - s.videoBytes - s.audioBytes,
            )
        } catch (e: SecurityException) {
            null
        }
        return mapOf(
            "totalBytes" to stats.getTotalBytes(uuid),
            "freeBytes" to stats.getFreeBytes(uuid),
            "breakdown" to breakdown,
        )
    }

    private fun battery(): Map<String, Any?> {
        val intent = activity.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val bm = activity.getSystemService(BatteryManager::class.java)
        val power = activity.getSystemService(PowerManager::class.java)
        val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, 100) ?: 100
        val current = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)
        val chargeLeft = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            bm.computeChargeTimeRemaining()
        } else {
            -1L
        }
        val cycles = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            intent?.getIntExtra(BatteryManager.EXTRA_CYCLE_COUNT, -1) ?: -1
        } else {
            -1
        }
        return mapOf(
            "percent" to if (level >= 0 && scale > 0) level * 100 / scale else -1,
            "status" to status(intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1),
            "plugged" to plugged(intent?.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0) ?: 0),
            "health" to health(intent?.getIntExtra(BatteryManager.EXTRA_HEALTH, -1) ?: -1),
            "temperatureTenthsC" to (intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, Int.MIN_VALUE)
                ?.takeIf { it != Int.MIN_VALUE }),
            "voltageMv" to (intent?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1)?.takeIf { it > 0 }),
            "technology" to intent?.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY),
            // Some phones report mA instead of µA, or 0 / MIN_VALUE when unsupported.
            "currentMicroA" to current.takeIf { it != 0 && it != Int.MIN_VALUE },
            "chargeTimeLeftMillis" to chargeLeft.takeIf { it > 0 },
            "cycleCount" to cycles.takeIf { it >= 0 },
            "powerSaveOn" to power.isPowerSaveMode,
        )
    }

    private fun memory(): Map<String, Any?> {
        val info = ActivityManager.MemoryInfo()
        activityManager().getMemoryInfo(info)
        return mapOf(
            "totalBytes" to info.totalMem,
            "availableBytes" to info.availMem,
            "thresholdBytes" to info.threshold,
            "isLow" to info.lowMemory,
        )
    }

    /** From Android 14 the system lets an app stop only its own processes. */
    private fun canStopBackgroundApps(): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE

    /**
     * Asks Android to stop the background processes of every installed (non-system) app.
     * Returns the number of apps asked and the measured change in available memory.
     */
    private fun stopBackgroundApps(): Map<String, Any?> {
        if (!canStopBackgroundApps()) return mapOf("apps" to 0, "freedBytes" to 0L)
        val am = activityManager()
        val before = memoryAvailable(am)
        val own = activity.packageName
        var asked = 0
        for (info in installedPackages(0)) {
            val app = info.applicationInfo ?: continue
            if (info.packageName == own || app.flags and ApplicationInfo.FLAG_SYSTEM != 0) continue
            am.killBackgroundProcesses(info.packageName)
            asked++
        }
        // Give the system a moment to reclaim the memory before measuring again.
        Thread.sleep(SETTLE_MILLIS)
        val freed = memoryAvailable(am) - before
        return mapOf("apps" to asked, "freedBytes" to if (freed > 0) freed else 0L)
    }

    /** Apps used in the last 24 hours, or null without Usage access. */
    private fun recentUsage(): List<Map<String, Any?>>? {
        val usm = activity.getSystemService(UsageStatsManager::class.java)
        val now = System.currentTimeMillis()
        val stats = usm.queryUsageStats(UsageStatsManager.INTERVAL_BEST, now - DAY_MILLIS, now)
        if (stats.isNullOrEmpty()) return if (hasUsageAccess(usm, now)) emptyList() else null
        return stats
            .filter { it.totalTimeInForeground > 0 && it.packageName != activity.packageName }
            .groupBy { it.packageName }
            .map { (pkg, rows) ->
                mapOf(
                    "packageName" to pkg,
                    "lastUsedMillis" to rows.maxOf { it.lastTimeUsed },
                    "foregroundMillis" to rows.sumOf { it.totalTimeInForeground },
                )
            }
    }

    /** Runtime (dangerous) permissions each app currently holds: package -> permission names. */
    private fun grantedPermissions(): Map<String, List<String>> {
        val dangerous = HashMap<String, Boolean>()
        val out = HashMap<String, List<String>>()
        for (info in installedPackages(PackageManager.GET_PERMISSIONS)) {
            val names = info.requestedPermissions ?: continue
            val flags = info.requestedPermissionsFlags ?: continue
            val granted = names.filterIndexed { i, name ->
                flags[i] and PackageInfo.REQUESTED_PERMISSION_GRANTED != 0 &&
                    dangerous.getOrPut(name) { isDangerous(name) }
            }
            if (granted.isNotEmpty()) out[info.packageName] = granted
        }
        return out
    }

    private fun isDangerous(name: String): Boolean = try {
        val perm = pm.getPermissionInfo(name, 0)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            perm.protection == PermissionInfo.PROTECTION_DANGEROUS
        } else {
            @Suppress("DEPRECATION")
            perm.protectionLevel and PermissionInfo.PROTECTION_MASK_BASE == PermissionInfo.PROTECTION_DANGEROUS
        }
    } catch (e: PackageManager.NameNotFoundException) {
        false
    }

    private fun clearOwnCache(): Long {
        var freed = 0L
        for (dir in ownCacheDirs()) {
            dir.listFiles()?.forEach { child ->
                val size = sizeOf(child)
                if (child.deleteRecursively()) freed += size
            }
        }
        return freed
    }

    private fun ownCacheDirs(): List<File> =
        listOfNotNull(activity.cacheDir, activity.externalCacheDir, activity.codeCacheDir)

    private fun sizeOf(file: File): Long =
        if (file.isDirectory) file.listFiles()?.sumOf { sizeOf(it) } ?: 0L else file.length()

    private fun openSystemScreen(screen: String?): Boolean {
        val action = when (screen) {
            "batterySaver" -> Settings.ACTION_BATTERY_SAVER_SETTINGS
            "batteryUsage" -> Intent.ACTION_POWER_USAGE_SUMMARY
            "batteryOptimization" -> Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS
            "storage" -> Settings.ACTION_INTERNAL_STORAGE_SETTINGS
            "freeUpSpace" -> StorageManager.ACTION_MANAGE_STORAGE
            "privacy" -> Settings.ACTION_PRIVACY_SETTINGS
            "display" -> Settings.ACTION_DISPLAY_SETTINGS
            else -> return false
        }
        return try {
            activity.startActivity(Intent(action).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
            true
        } catch (e: Exception) {
            false
        }
    }

    private fun activityManager(): ActivityManager =
        activity.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager

    private fun memoryAvailable(am: ActivityManager): Long =
        ActivityManager.MemoryInfo().also { am.getMemoryInfo(it) }.availMem

    /** An empty result from queryUsageStats means either no use or no access; this tells which. */
    private fun hasUsageAccess(usm: UsageStatsManager, now: Long): Boolean =
        usm.queryEvents(now - DAY_MILLIS, now).hasNextEvent()

    private fun installedPackages(flags: Int): List<PackageInfo> =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pm.getInstalledPackages(PackageManager.PackageInfoFlags.of(flags.toLong()))
        } else {
            @Suppress("DEPRECATION")
            pm.getInstalledPackages(flags)
        }

    private fun status(raw: Int): String = when (raw) {
        BatteryManager.BATTERY_STATUS_CHARGING -> "charging"
        BatteryManager.BATTERY_STATUS_DISCHARGING -> "discharging"
        BatteryManager.BATTERY_STATUS_FULL -> "full"
        BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "notCharging"
        else -> "unknown"
    }

    private fun plugged(raw: Int): String = when (raw) {
        BatteryManager.BATTERY_PLUGGED_AC -> "ac"
        BatteryManager.BATTERY_PLUGGED_USB -> "usb"
        BatteryManager.BATTERY_PLUGGED_WIRELESS -> "wireless"
        0 -> "none"
        else -> "other"
    }

    private fun health(raw: Int): String = when (raw) {
        BatteryManager.BATTERY_HEALTH_GOOD -> "good"
        BatteryManager.BATTERY_HEALTH_OVERHEAT -> "overheat"
        BatteryManager.BATTERY_HEALTH_DEAD -> "dead"
        BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "overVoltage"
        BatteryManager.BATTERY_HEALTH_COLD -> "cold"
        BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "failure"
        else -> "unknown"
    }

    /** Runs [work] off the main thread and replies on it. */
    private fun background(result: MethodChannel.Result, work: () -> Any?) {
        worker.execute {
            try {
                val value = work()
                main.post { result.success(value) }
            } catch (e: Exception) {
                main.post { result.error("native_error", e.message, null) }
            }
        }
    }

    private companion object {
        const val CHANNEL = "com.homilabs.phonemanager/device"
        const val DAY_MILLIS = 24L * 60 * 60 * 1000
        const val SETTLE_MILLIS = 800L
    }
}
