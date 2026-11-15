import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';

/// Phone-wide readings from Android. Throws [PlatformException] on a native error;
/// the repository turns that into a typed failure.
abstract interface class DevicePlatformService {
  Future<StorageStatus> storage();

  Future<BatteryStatus> battery();

  Future<MemoryStatus> memory();

  /// False from Android 14, where only the system can stop other apps.
  Future<bool> canStopBackgroundApps();

  Future<StopReport> stopBackgroundApps();

  /// Apps used in the last 24 hours, or null without usage access.
  Future<List<AppUsage>?> recentUsage();

  /// Package name -> runtime permissions it currently holds.
  Future<Map<String, List<String>>> grantedPermissions();

  Future<int> ownCacheBytes();

  /// Returns the bytes freed.
  Future<int> clearOwnCache();

  /// False when Android had no such screen.
  Future<bool> openSystemScreen(SystemScreen screen);
}

/// [DevicePlatformService] over the `com.homilabs.phonemanager/device` channel (DeviceChannel.kt).
class MethodChannelDevicePlatformService implements DevicePlatformService {
  const MethodChannelDevicePlatformService();

  static const _channel = MethodChannel('com.homilabs.phonemanager/device');

  @override
  Future<StorageStatus> storage() async {
    final m = await _channel.invokeMapMethod<String, Object?>('storage') ?? const {};
    final b = m['breakdown'] as Map<Object?, Object?>?;
    return StorageStatus(
      totalBytes: _int(m['totalBytes']),
      freeBytes: _int(m['freeBytes']),
      breakdown: b == null
          ? null
          : StorageBreakdown(
              imageBytes: _int(b['images']),
              videoBytes: _int(b['videos']),
              audioBytes: _int(b['audio']),
              otherFileBytes: _int(b['files']),
            ),
    );
  }

  @override
  Future<BatteryStatus> battery() async {
    final m = await _channel.invokeMapMethod<String, Object?>('battery') ?? const {};
    return BatteryStatus.parse(
      percent: (m['percent'] as num?)?.toInt() ?? -1,
      status: m['status'] as String?,
      source: m['plugged'] as String?,
      health: m['health'] as String?,
      powerSaveOn: m['powerSaveOn'] == true,
      temperatureTenthsC: _intOrNull(m['temperatureTenthsC']),
      voltageMv: _intOrNull(m['voltageMv']),
      technology: m['technology'] as String?,
      currentMicroA: _intOrNull(m['currentMicroA']),
      chargeTimeLeftMillis: _intOrNull(m['chargeTimeLeftMillis']),
      cycleCount: _intOrNull(m['cycleCount']),
    );
  }

  @override
  Future<MemoryStatus> memory() async {
    final m = await _channel.invokeMapMethod<String, Object?>('memory') ?? const {};
    return MemoryStatus(
      totalBytes: _int(m['totalBytes']),
      availableBytes: _int(m['availableBytes']),
      thresholdBytes: _int(m['thresholdBytes']),
      isLow: m['isLow'] == true,
    );
  }

  @override
  Future<bool> canStopBackgroundApps() async =>
      await _channel.invokeMethod<bool>('canStopBackgroundApps') ?? false;

  @override
  Future<StopReport> stopBackgroundApps() async {
    final m = await _channel.invokeMapMethod<String, Object?>('stopBackgroundApps') ?? const {};
    return (apps: _int(m['apps']), freedBytes: _int(m['freedBytes']));
  }

  @override
  Future<List<AppUsage>?> recentUsage() async {
    final raw = await _channel.invokeListMethod<Map<Object?, Object?>>('recentUsage');
    if (raw == null) return null;
    return [
      for (final m in raw)
        AppUsage(
          packageName: m['packageName']! as String,
          lastUsed: DateTime.fromMillisecondsSinceEpoch(_int(m['lastUsedMillis'])),
          foreground: Duration(milliseconds: _int(m['foregroundMillis'])),
        ),
    ];
  }

  @override
  Future<Map<String, List<String>>> grantedPermissions() async {
    final raw = await _channel.invokeMapMethod<String, List<Object?>>('grantedPermissions');
    return {
      for (final MapEntry(:key, :value) in (raw ?? const {}).entries) key: value.cast<String>(),
    };
  }

  @override
  Future<int> ownCacheBytes() async => _int(await _channel.invokeMethod<Object?>('ownCacheBytes'));

  @override
  Future<int> clearOwnCache() async => _int(await _channel.invokeMethod<Object?>('clearOwnCache'));

  @override
  Future<bool> openSystemScreen(SystemScreen screen) async =>
      await _channel.invokeMethod<bool>('openSystemScreen', {'screen': screen.name}) ?? false;

  static int _int(Object? v) => (v as num?)?.toInt() ?? 0;

  static int? _intOrNull(Object? v) => (v as num?)?.toInt();
}

final Provider<DevicePlatformService> devicePlatformServiceProvider =
    Provider<DevicePlatformService>((ref) => const MethodChannelDevicePlatformService());
