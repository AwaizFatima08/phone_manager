import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/features/apps/data/app_platform_service.dart';
import 'package:phonemanager/features/device/data/device_platform_service.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';

import 'support/fake_device.dart';
import 'support/fake_platform.dart';

void main() {
  Future<(FakePlatform, FakeDevice)> pump(
    WidgetTester tester, {
    FakeDevice? device,
    bool access = true,
  }) async {
    final platform = FakePlatform(
      apps: [
        fakeApp('com.a.alpha', label: 'Alpha'),
        fakeApp('com.b.beta', label: 'Beta'),
        fakeApp('android.sys', label: 'System UI', isSystem: true),
      ],
      sizeMap: access
          ? {
              'com.a.alpha': fakeSize(2000000, cache: 300000),
              'com.b.beta': fakeSize(5000, cache: 1000),
            }
          : null,
    );
    final fake =
        device ??
        FakeDevice(
          granted: {
            'com.a.alpha': ['android.permission.ACCESS_FINE_LOCATION', 'android.permission.CAMERA'],
            'com.b.beta': ['android.permission.ACCESS_COARSE_LOCATION'],
            'android.sys': ['android.permission.RECORD_AUDIO'],
          },
          usage: [
            AppUsage(
              packageName: 'com.b.beta',
              lastUsed: DateTime.utc(2026, 11, 15),
              foreground: const Duration(hours: 1, minutes: 5),
            ),
          ],
        );
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          appPlatformServiceProvider.overrideWithValue(platform),
          devicePlatformServiceProvider.overrideWithValue(fake),
        ],
        child: const PhoneManagerApp(),
      ),
    );
    await tester.pumpAndSettle();
    return (platform, fake);
  }

  Future<void> open(WidgetTester tester, String tool) async {
    await tester.tap(find.text(tool));
    await tester.pumpAndSettle();
  }

  testWidgets('home shows a live summary on every tool', (tester) async {
    await pump(tester);
    expect(find.text('48 GB free of 128 GB'), findsOneWidget);
    expect(find.text('82% · charging'), findsOneWidget);
    expect(find.text('2 apps'), findsOneWidget);
    expect(find.text('3 GB free of 8 GB'), findsOneWidget);
    expect(find.text('301 KB of cache in apps'), findsOneWidget);
    expect(find.text('2 apps can use your location'), findsOneWidget);
  });

  testWidgets('storage shows use, breakdown and opens free up space', (tester) async {
    final (_, device) = await pump(tester);
    await open(tester, 'Storage');
    expect(find.text('80 GB of 128 GB used'), findsOneWidget);
    expect(find.text('5 GB'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Open free up space'), 200);
    await tester.ensureVisible(find.text('Open free up space'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open free up space'));
    await tester.pumpAndSettle();
    expect(device.opened, [SystemScreen.freeUpSpace]);
  });

  testWidgets('battery shows level, charging line and details', (tester) async {
    await pump(tester);
    await open(tester, 'Battery');
    expect(find.text('82%'), findsOneWidget);
    expect(find.text('Charging · charger · full in 0 h 45 min'), findsOneWidget);
    expect(find.text('31.2 °C'), findsOneWidget);
    expect(find.text('1500 mA'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('1 h 5 min'), 200);
    expect(find.text('1 h 5 min'), findsOneWidget);
  });

  testWidgets('memory stops background apps and reports the measured gain', (tester) async {
    final (_, device) = await pump(tester);
    await open(tester, 'Memory');
    await tester.tap(find.widgetWithText(FilledButton, 'Stop background apps'));
    await tester.pump();
    await tester.pump();
    expect(device.stopCalls, 1);
    expect(find.text('Asked 12 apps to stop. 150 MB more memory is free now.'), findsOneWidget);
  });

  testWidgets('memory explains Android 14 instead of offering the button', (tester) async {
    await pump(tester, device: FakeDevice(canStop: false));
    await open(tester, 'Memory');
    expect(find.widgetWithText(FilledButton, 'Stop background apps'), findsNothing);
    expect(find.textContaining('From Android 14'), findsOneWidget);
  });

  testWidgets('cache cleaner clears its own cache and guides the rest', (tester) async {
    final (platform, _) = await pump(tester);
    await open(tester, 'Cache cleaner');
    expect(find.text('2 MB'), findsOneWidget);
    await tester.tap(find.text('Clear now'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Cleared 2 MB.'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.scrollUntilVisible(find.text('Beta'), 200);
    await tester.ensureVisible(find.text('Beta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    expect(platform.opened, ['settings:com.a.alpha']);
  });

  testWidgets('permissions groups apps by what they may use, skipping system apps', (
    tester,
  ) async {
    await pump(tester);
    await open(tester, 'App permissions');
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Microphone'), findsNothing);
    await tester.tap(find.text('Location'));
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
  });

  testWidgets('without usage access the home asks for it', (tester) async {
    await pump(tester, access: false, device: FakeDevice(usage: null, breakdown: null));
    expect(find.text('See sizes, cache and screen time'), findsOneWidget);
    expect(find.text('Needs usage access'), findsOneWidget);
  });
}
