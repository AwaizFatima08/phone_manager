import 'package:flutter_test/flutter_test.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';
import 'package:phonemanager/features/device/domain/permission_overview.dart';

void main() {
  group('permission groups', () {
    test('runtime permissions map to the groups Android shows', () {
      expect(
        PermissionGroup.of('android.permission.ACCESS_FINE_LOCATION'),
        PermissionGroup.location,
      );
      expect(PermissionGroup.of('android.permission.CAMERA'), PermissionGroup.camera);
      expect(
        PermissionGroup.of('android.permission.READ_MEDIA_IMAGES'),
        PermissionGroup.photosAndMedia,
      );
      expect(
        PermissionGroup.of('android.permission.POST_NOTIFICATIONS'),
        PermissionGroup.notifications,
      );
      expect(PermissionGroup.of('com.example.CUSTOM'), PermissionGroup.other);
    });

    test('overview counts each app once per group, most-shared group first', () {
      final overview = PermissionOverview.from(const {
        'com.b': ['android.permission.CAMERA', 'android.permission.ACCESS_FINE_LOCATION'],
        'com.a': [
          'android.permission.ACCESS_FINE_LOCATION',
          'android.permission.ACCESS_COARSE_LOCATION',
        ],
        'android.sys': ['android.permission.CAMERA'],
      }, include: (p) => p != 'android.sys');
      expect(overview.appsByGroup.keys.toList(), [
        PermissionGroup.location,
        PermissionGroup.camera,
      ]);
      expect(overview.appsWith(PermissionGroup.location), ['com.a', 'com.b']);
      expect(overview.appsWith(PermissionGroup.camera), ['com.b']);
      expect(overview.appsWith(PermissionGroup.microphone), isEmpty);
    });
  });

  group('battery', () {
    test('current is taken as µA unless it is already small enough to be mA', () {
      expect(BatteryStatus.normaliseCurrent(1500000), 1500);
      expect(BatteryStatus.normaliseCurrent(-850000), -850);
      expect(BatteryStatus.normaliseCurrent(1500), 1500);
    });

    test('parse maps native strings and units, unknown strings fall back', () {
      final b = BatteryStatus.parse(
        percent: 50,
        status: 'weird',
        source: 'usb',
        health: 'overheat',
        powerSaveOn: true,
        temperatureTenthsC: 461,
        technology: '',
      );
      expect(b.status, ChargeStatus.unknown);
      expect(b.source, PowerSource.usb);
      expect(b.health, BatteryHealth.overheat);
      expect(b.temperatureC, 46.1);
      expect(b.isHot, isTrue);
      expect(b.technology, isNull);
    });
  });

  test('storage and memory fractions are total-safe', () {
    expect(const StorageStatus(totalBytes: 0, freeBytes: 10).usedFraction, 0);
    expect(const StorageStatus(totalBytes: 100, freeBytes: 25).usedFraction, 0.75);
    const m = MemoryStatus(totalBytes: 100, availableBytes: 120, thresholdBytes: 0, isLow: false);
    expect(m.usedBytes, 0);
  });
}
