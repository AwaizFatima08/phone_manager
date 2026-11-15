import 'package:phonemanager/features/device/data/device_platform_service.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';

/// An in-memory phone for the device readings.
class FakeDevice implements DevicePlatformService {
  FakeDevice({
    this.canStop = true,
    this.usage = const [],
    this.granted = const {},
    this.ownCache = 2000000,
    this.breakdown = const StorageBreakdown(
      imageBytes: 3000000000,
      videoBytes: 5000000000,
      audioBytes: 100000000,
      otherFileBytes: 900000000,
    ),
  });

  bool canStop;
  List<AppUsage>? usage;
  Map<String, List<String>> granted;
  int ownCache;
  StorageBreakdown? breakdown;
  final List<SystemScreen> opened = [];
  int stopCalls = 0;

  @override
  Future<StorageStatus> storage() async =>
      StorageStatus(totalBytes: 128000000000, freeBytes: 48000000000, breakdown: breakdown);

  @override
  Future<BatteryStatus> battery() async => BatteryStatus.parse(
    percent: 82,
    status: 'charging',
    source: 'ac',
    health: 'good',
    powerSaveOn: false,
    temperatureTenthsC: 312,
    voltageMv: 4123,
    technology: 'Li-ion',
    currentMicroA: 1500000,
    chargeTimeLeftMillis: 45 * 60 * 1000,
  );

  @override
  Future<MemoryStatus> memory() async => const MemoryStatus(
    totalBytes: 8000000000,
    availableBytes: 3000000000,
    thresholdBytes: 200000000,
    isLow: false,
  );

  @override
  Future<bool> canStopBackgroundApps() async => canStop;

  @override
  Future<StopReport> stopBackgroundApps() async {
    stopCalls++;
    return (apps: 12, freedBytes: 150000000);
  }

  @override
  Future<List<AppUsage>?> recentUsage() async => usage;

  @override
  Future<Map<String, List<String>>> grantedPermissions() async => granted;

  @override
  Future<int> ownCacheBytes() async => ownCache;

  @override
  Future<int> clearOwnCache() async {
    final freed = ownCache;
    ownCache = 0;
    return freed;
  }

  @override
  Future<bool> openSystemScreen(SystemScreen screen) async {
    opened.add(screen);
    return true;
  }
}
