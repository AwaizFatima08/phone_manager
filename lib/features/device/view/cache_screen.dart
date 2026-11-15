import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/ads/ad_service.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/core/byte_size.dart';
import 'package:phonemanager/core/result.dart';
import 'package:phonemanager/features/apps/application/app_providers.dart';
import 'package:phonemanager/features/apps/domain/app_query.dart';
import 'package:phonemanager/features/apps/view/widgets/app_icon.dart';
import 'package:phonemanager/features/apps/view/widgets/settings_guide_sheet.dart';
import 'package:phonemanager/features/apps/view/widgets/usage_access_banner.dart';
import 'package:phonemanager/features/device/application/device_providers.dart';
import 'package:phonemanager/features/device/data/device_repository.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';
import 'package:phonemanager/ui/meter.dart';
import 'package:phonemanager/ui/system_screen.dart';
import 'package:phonemanager/ui/theme.dart';

/// Cache cleaner: clears Phone Manager's own cache, and lists every other app's cache
/// largest first with a guided jump to its App info page (the only place Android allows it).
class CacheScreen extends ConsumerWidget {
  const CacheScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final noAccess = ref.watch(sizeReportProvider).value?.hasUsageAccess == false;
    final entries = ref.watch(cacheAppsProvider);
    final total = ref.watch(totalCacheBytesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cacheTool)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(ownCacheBytesProvider);
          await ref.read(sizeReportProvider.notifier).refresh();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: screenPadding,
          children: [
            if (noAccess) const UsageAccessBanner(margin: UsageAccessBanner.inListMargin),
            if (total != null)
              SectionCard(
                children: [
                  Text(
                    l10n.cacheInApps(formatBytes(total, locale: locale)),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(l10n.cacheExplainer, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            const _OwnCacheCard(),
            SectionCard(
              title: l10n.freeUpSpaceTitle,
              children: [
                Text(l10n.cacheFreeUpBody),
                const SizedBox(height: AppSpacing.md),
                SystemScreenButton(
                  screen: SystemScreen.freeUpSpace,
                  label: l10n.freeUpSpaceButton,
                ),
              ],
            ),
            if (entries != null && entries.isNotEmpty)
              SectionCard(
                title: l10n.cacheByApp,
                children: [for (final e in entries) _CacheTile(entry: e)],
              )
            else if (entries != null)
              SectionCard(children: [Text(l10n.noCache)])
            else if (!noAccess)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class _OwnCacheCard extends ConsumerStatefulWidget {
  const _OwnCacheCard();

  @override
  ConsumerState<_OwnCacheCard> createState() => _OwnCacheCardState();
}

class _OwnCacheCardState extends ConsumerState<_OwnCacheCard> {
  bool _busy = false;

  Future<void> _clear() async {
    setState(() => _busy = true);
    final result = await ref.read(deviceRepositoryProvider).clearOwnCache();
    if (!mounted) return;
    setState(() => _busy = false);
    ref.invalidate(ownCacheBytesProvider);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final message = switch (result) {
      Ok(:final value) => l10n.ownCacheCleared(formatBytes(value, locale: locale)),
      Err() => l10n.ownCacheFailed,
    };
    await ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))).closed;
    if (result is Ok) await ref.read(adServiceProvider).showBreakInterstitial();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final own = ref.watch(ownCacheBytesProvider).value;
    return SectionCard(
      title: l10n.ownCacheTitle,
      children: [
        InfoRow(
          label: l10n.ownCacheLabel,
          value: own == null ? '…' : formatBytes(own, locale: locale),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _busy || own == null || own == 0 ? null : _clear,
            icon: const Icon(Icons.cleaning_services_outlined),
            label: Text(l10n.clearNow),
          ),
        ),
      ],
    );
  }
}

class _CacheTile extends ConsumerWidget {
  const _CacheTile({required this.entry});

  final AppEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    return ListTile(
      contentPadding: EdgeInsetsDirectional.zero,
      leading: AppIcon(packageName: entry.app.packageName),
      title: Text(entry.app.label, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        formatBytes(entry.size!.cacheBytes, locale: locale),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.amber),
      ),
      onTap: () => unawaited(
        showSettingsGuide(
          context,
          ref,
          packageName: entry.app.packageName,
          title: l10n.clearCacheSheetTitle,
          body: l10n.clearCacheSheetBody,
          steps: [l10n.clearCacheStep1, l10n.clearCacheStep2, l10n.clearCacheStep3],
        ),
      ),
    );
  }
}
