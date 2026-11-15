import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/features/device/application/device_providers.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';
import 'package:phonemanager/features/device/view/widgets/screen_time_list.dart';
import 'package:phonemanager/l10n/gen/app_localizations.dart';
import 'package:phonemanager/ui/load_error.dart';
import 'package:phonemanager/ui/meter.dart';
import 'package:phonemanager/ui/system_screen.dart';
import 'package:phonemanager/ui/theme.dart';

/// Battery: live level, charging, health and temperature, plus battery saver and usage pages.
class PowerScreen extends ConsumerWidget {
  const PowerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.powerTool)),
      body: switch (ref.watch(batteryStatusProvider)) {
        AsyncData(:final value) => _PowerBody(battery: value),
        AsyncError(:final error) => Center(
          child: LoadError(error: error, onRetry: () => ref.invalidate(batteryStatusProvider)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _PowerBody extends StatelessWidget {
  const _PowerBody({required this.battery});

  final BatteryStatus battery;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final b = battery;
    final known = b.percent >= 0;
    return ListView(
      padding: screenPadding,
      children: [
        SectionCard(
          children: [
            Meter(
              headline: known ? l10n.batteryPercent(b.percent) : l10n.unknown,
              fraction: known ? b.percent / 100 : 0,
              warn: known && b.percent <= 15 && !b.isCharging,
              caption: _chargeLine(l10n, b),
            ),
          ],
        ),
        SectionCard(
          title: l10n.batteryDetails,
          children: [
            InfoRow(label: l10n.batteryHealth, value: _health(l10n, b.health)),
            if (b.temperatureC case final t?)
              InfoRow(
                label: l10n.batteryTemperature,
                value: l10n.celsius(t.toStringAsFixed(1)),
                leading: b.isHot ? const Icon(Icons.warning_amber, color: AppColors.amber) : null,
              ),
            if (b.voltageMv case final v?)
              InfoRow(label: l10n.batteryVoltage, value: l10n.volts((v / 1000).toStringAsFixed(2))),
            if (b.currentMilliA case final c?)
              InfoRow(label: l10n.batteryCurrent, value: l10n.milliAmps(c)),
            if (b.cycleCount case final n?) InfoRow(label: l10n.batteryCycles, value: '$n'),
            if (b.technology case final t?) InfoRow(label: l10n.batteryTechnology, value: t),
            InfoRow(
              label: l10n.batterySaver,
              value: b.powerSaveOn ? l10n.on : l10n.off,
            ),
          ],
        ),
        if (b.isHot)
          SectionCard(
            children: [Text(l10n.batteryHotTip)],
          ),
        SectionCard(
          title: l10n.saveBatteryTitle,
          children: [
            Text(l10n.saveBatteryBody),
            const SizedBox(height: AppSpacing.md),
            SystemScreenButton(screen: SystemScreen.batterySaver, label: l10n.batterySaverButton),
            const SizedBox(height: AppSpacing.sm),
            SystemScreenButton(screen: SystemScreen.batteryUsage, label: l10n.batteryUsageButton),
            const SizedBox(height: AppSpacing.sm),
            SystemScreenButton(
              screen: SystemScreen.batteryOptimization,
              label: l10n.batteryOptimizationButton,
            ),
          ],
        ),
        SectionCard(
          title: l10n.screenTimeTitle,
          children: [
            Text(l10n.screenTimeBody, style: Theme.of(context).textTheme.bodySmall),
            const ScreenTimeList(limit: 8),
          ],
        ),
      ],
    );
  }

  static String _chargeLine(AppLocalizations l10n, BatteryStatus b) {
    final source = switch (b.source) {
      PowerSource.ac => l10n.sourceCharger,
      PowerSource.usb => l10n.sourceUsb,
      PowerSource.wireless => l10n.sourceWireless,
      PowerSource.other => l10n.sourceOther,
      PowerSource.none => null,
    };
    final status = switch (b.status) {
      ChargeStatus.charging => l10n.statusCharging,
      ChargeStatus.full => l10n.statusFull,
      ChargeStatus.discharging => l10n.statusOnBattery,
      ChargeStatus.notCharging => l10n.statusNotCharging,
      ChargeStatus.unknown => l10n.unknown,
    };
    final left = b.chargeTimeLeft;
    return [
      status,
      ?source,
      if (left != null && b.status == ChargeStatus.charging)
        l10n.fullIn(left.inHours, left.inMinutes.remainder(60)),
    ].join(' · ');
  }

  static String _health(AppLocalizations l10n, BatteryHealth h) => switch (h) {
    BatteryHealth.good => l10n.healthGood,
    BatteryHealth.overheat => l10n.healthOverheat,
    BatteryHealth.dead => l10n.healthDead,
    BatteryHealth.overVoltage => l10n.healthOverVoltage,
    BatteryHealth.cold => l10n.healthCold,
    BatteryHealth.failure => l10n.healthFailure,
    BatteryHealth.unknown => l10n.unknown,
  };
}
