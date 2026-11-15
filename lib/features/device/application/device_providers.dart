import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/core/result.dart';
import 'package:phonemanager/features/apps/application/app_providers.dart';
import 'package:phonemanager/features/apps/domain/app_query.dart';
import 'package:phonemanager/features/device/data/device_repository.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';
import 'package:phonemanager/features/device/domain/permission_overview.dart';

/// How often the battery and memory screens re-read their figures while open.
const batteryPollInterval = Duration(seconds: 5);
const memoryPollInterval = Duration(seconds: 3);

T _unwrap<T>(Result<T, PlatformFailure> result) => switch (result) {
  Ok(:final value) => value,
  Err(:final failure) => throw failure,
};

/// Re-reads [read] at once and then every [every] while someone listens.
Stream<T> _poll<T>(Duration every, Future<T> Function() read) async* {
  yield await read();
  yield* Stream<void>.periodic(every).asyncMap((_) => read());
}

final storageStatusProvider = FutureProvider<StorageStatus>(
  (ref) async => _unwrap(await ref.watch(deviceRepositoryProvider).storage()),
);

final batteryStatusProvider = StreamProvider<BatteryStatus>((ref) {
  final repository = ref.watch(deviceRepositoryProvider);
  return _poll(batteryPollInterval, () async => _unwrap(await repository.battery()));
});

final memoryStatusProvider = StreamProvider<MemoryStatus>((ref) {
  final repository = ref.watch(deviceRepositoryProvider);
  return _poll(memoryPollInterval, () async => _unwrap(await repository.memory()));
});

final canStopBackgroundAppsProvider = FutureProvider<bool>(
  (ref) => ref.watch(deviceRepositoryProvider).canStopBackgroundApps(),
);

/// Apps used in the last 24 hours, most screen time first; null without usage access.
final recentUsageProvider = FutureProvider<List<AppUsage>?>((ref) async {
  final usage = _unwrap<List<AppUsage>?>(
    await ref.watch(deviceRepositoryProvider).recentUsage(),
  );
  if (usage == null) return null;
  final sorted = [...usage]..sort((a, b) => b.foreground.compareTo(a.foreground));
  return List.unmodifiable(sorted);
});

/// Which installed (non-system) apps hold each runtime permission group.
final permissionOverviewProvider = FutureProvider<PermissionOverview>((ref) async {
  final apps = await ref.watch(installedAppsProvider.future);
  final userApps = {
    for (final a in apps)
      if (!a.isSystem || a.isUpdatedSystem) a.packageName,
  };
  final granted = _unwrap(await ref.watch(deviceRepositoryProvider).grantedPermissions());
  return PermissionOverview.from(granted, include: userApps.contains);
});

/// Bytes in Phone Manager's own cache, which it may clear itself.
final ownCacheBytesProvider = FutureProvider<int>(
  (ref) async => _unwrap(await ref.watch(deviceRepositoryProvider).ownCacheBytes()),
);

/// Every app with cache, largest first; null until sizes are known (or without usage access).
final cacheAppsProvider = Provider<List<AppEntry>?>((ref) {
  final apps = ref.watch(installedAppsProvider).value;
  final report = ref.watch(sizeReportProvider).value;
  if (apps == null || report == null || !report.hasUsageAccess) return null;
  final entries = [
    for (final a in apps)
      if ((report.sizes[a.packageName]?.cacheBytes ?? 0) > 0)
        AppEntry(a, report.sizes[a.packageName]),
  ]..sort((a, b) => b.size!.cacheBytes.compareTo(a.size!.cacheBytes));
  return List.unmodifiable(entries);
});

/// Total cache across [cacheAppsProvider].
final totalCacheBytesProvider = Provider<int?>((ref) {
  final entries = ref.watch(cacheAppsProvider);
  return entries?.fold<int>(0, (sum, e) => sum + e.size!.cacheBytes);
});

/// Total app size (code + data) across all apps; null without sizes.
final totalAppBytesProvider = Provider<int?>((ref) {
  final report = ref.watch(sizeReportProvider).value;
  if (report == null || !report.hasUsageAccess) return null;
  return report.sizes.values.fold<int>(0, (sum, s) => sum + s.totalBytes);
});
