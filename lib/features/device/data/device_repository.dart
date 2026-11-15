import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/core/result.dart';
import 'package:phonemanager/features/device/data/device_platform_service.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';

/// The single route to phone-wide readings. Every call returns a value or a typed failure.
class DeviceRepository {
  const DeviceRepository(this._platform);

  final DevicePlatformService _platform;

  Future<Result<StorageStatus, PlatformFailure>> storage() => _guard('storage', _platform.storage);

  Future<Result<BatteryStatus, PlatformFailure>> battery() => _guard('battery', _platform.battery);

  Future<Result<MemoryStatus, PlatformFailure>> memory() => _guard('memory', _platform.memory);

  Future<bool> canStopBackgroundApps() async =>
      switch (await _guard('can_stop', _platform.canStopBackgroundApps)) {
        Ok(:final value) => value,
        Err() => false,
      };

  Future<Result<StopReport, PlatformFailure>> stopBackgroundApps() =>
      _guard('stop_background', _platform.stopBackgroundApps);

  Future<Result<List<AppUsage>?, PlatformFailure>> recentUsage() =>
      _guard('recent_usage', _platform.recentUsage);

  Future<Result<Map<String, List<String>>, PlatformFailure>> grantedPermissions() =>
      _guard('granted_permissions', _platform.grantedPermissions);

  Future<Result<int, PlatformFailure>> ownCacheBytes() =>
      _guard('own_cache', _platform.ownCacheBytes);

  Future<Result<int, PlatformFailure>> clearOwnCache() =>
      _guard('clear_own_cache', _platform.clearOwnCache);

  Future<bool> openSystemScreen(SystemScreen screen) async =>
      switch (await _guard('open_${screen.name}', () => _platform.openSystemScreen(screen))) {
        Ok(:final value) => value,
        Err() => false,
      };

  static Future<Result<T, PlatformFailure>> _guard<T>(
    String code,
    Future<T> Function() call,
  ) async {
    try {
      return Ok(await call());
    } on PlatformException catch (e) {
      return Err(PlatformFailure(code, cause: e));
    } on MissingPluginException catch (e) {
      return Err(PlatformFailure(code, cause: e));
    }
  }
}

final Provider<DeviceRepository> deviceRepositoryProvider = Provider<DeviceRepository>(
  (ref) => DeviceRepository(ref.watch(devicePlatformServiceProvider)),
);
