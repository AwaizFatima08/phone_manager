import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/ads/ad_service.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/core/byte_size.dart';
import 'package:phonemanager/core/result.dart';
import 'package:phonemanager/features/device/application/device_providers.dart';
import 'package:phonemanager/features/device/data/device_repository.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';
import 'package:phonemanager/features/device/view/widgets/screen_time_list.dart';
import 'package:phonemanager/ui/load_error.dart';
import 'package:phonemanager/ui/meter.dart';
import 'package:phonemanager/ui/theme.dart';

/// Memory (RAM): live use, "Stop background apps" where Android still allows it, and the
/// apps used most today.
class MemoryScreen extends ConsumerWidget {
  const MemoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.memoryTool)),
      body: switch (ref.watch(memoryStatusProvider)) {
        AsyncData(:final value) => _MemoryBody(memory: value),
        AsyncError(:final error) => Center(
          child: LoadError(error: error, onRetry: () => ref.invalidate(memoryStatusProvider)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _MemoryBody extends ConsumerWidget {
  const _MemoryBody({required this.memory});

  final MemoryStatus memory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    String bytes(int b) => formatBytes(b, locale: locale);
    final canStop = ref.watch(canStopBackgroundAppsProvider).value;
    return ListView(
      padding: screenPadding,
      children: [
        SectionCard(
          children: [
            Meter(
              headline: l10n.usedOf(bytes(memory.usedBytes), bytes(memory.totalBytes)),
              fraction: memory.usedFraction,
              warn: memory.isLow,
              caption: memory.isLow
                  ? l10n.memoryLow
                  : l10n.memoryFree(bytes(memory.availableBytes)),
            ),
          ],
        ),
        SectionCard(
          title: l10n.stopBackgroundTitle,
          children: [
            if (canStop == true) ...[
              Text(l10n.stopBackgroundBody),
              const SizedBox(height: AppSpacing.md),
              const _StopButton(),
            ] else if (canStop == false)
              Text(l10n.stopBackgroundUnavailable),
          ],
        ),
        SectionCard(
          title: l10n.screenTimeTitle,
          children: [
            Text(l10n.memoryAppsBody, style: Theme.of(context).textTheme.bodySmall),
            const ScreenTimeList(),
          ],
        ),
      ],
    );
  }
}

class _StopButton extends ConsumerStatefulWidget {
  const _StopButton();

  @override
  ConsumerState<_StopButton> createState() => _StopButtonState();
}

class _StopButtonState extends ConsumerState<_StopButton> {
  bool _busy = false;

  Future<void> _stop() async {
    setState(() => _busy = true);
    final result = await ref.read(deviceRepositoryProvider).stopBackgroundApps();
    if (!mounted) return;
    setState(() => _busy = false);
    ref.invalidate(memoryStatusProvider);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final message = switch (result) {
      Ok(value: (:final apps, :final freedBytes)) =>
        freedBytes > 0
            ? l10n.stopReport(apps, formatBytes(freedBytes, locale: locale))
            : l10n.stopReportNoGain(apps),
      Err() => l10n.stopFailed,
    };
    await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))).closed;
    if (result is Ok) await ref.read(adServiceProvider).showBreakInterstitial();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton.icon(
      onPressed: _busy ? null : _stop,
      icon: _busy
          ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.stop_circle_outlined),
      label: Text(context.l10n.stopBackgroundButton),
    ),
  );
}
