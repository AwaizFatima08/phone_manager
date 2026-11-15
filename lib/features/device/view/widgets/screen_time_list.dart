import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/features/apps/application/app_providers.dart';
import 'package:phonemanager/features/apps/view/app_detail_screen.dart';
import 'package:phonemanager/features/apps/view/widgets/app_icon.dart';
import 'package:phonemanager/features/apps/view/widgets/usage_access_banner.dart';
import 'package:phonemanager/features/device/application/device_providers.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';

/// The apps with the most screen time in the last 24 hours. Tapping one opens its details.
class ScreenTimeList extends ConsumerWidget {
  const ScreenTimeList({this.limit = 10, super.key});

  final int limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return switch (ref.watch(recentUsageProvider)) {
      AsyncData(value: null) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton(
          onPressed: () => openUsageAccess(context, ref),
          child: Text(l10n.allowUsageAccessForScreenTime),
        ),
      ),
      AsyncData(:final value?) when value.isEmpty => Padding(
        padding: const EdgeInsetsDirectional.only(top: 8),
        child: Text(l10n.noRecentUse),
      ),
      AsyncData(:final value?) => Column(
        children: [for (final u in value.take(limit)) _UsageTile(usage: u)],
      ),
      AsyncError() => Text(l10n.noRecentUse),
      _ => const Padding(
        padding: EdgeInsetsDirectional.all(8),
        child: Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _UsageTile extends ConsumerWidget {
  const _UsageTile({required this.usage});

  final AppUsage usage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(appByPackageProvider(usage.packageName));
    final minutes = usage.foreground.inMinutes;
    return ListTile(
      contentPadding: EdgeInsetsDirectional.zero,
      leading: AppIcon(packageName: usage.packageName),
      title: Text(
        entry?.app.label ?? usage.packageName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        context.l10n.durationHm(minutes ~/ 60, minutes % 60),
        style: Theme.of(context).textTheme.labelLarge,
      ),
      onTap: entry == null
          ? null
          : () => unawaited(
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AppDetailScreen(packageName: usage.packageName),
                ),
              ),
            ),
    );
  }
}
