import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/core/byte_size.dart';
import 'package:phonemanager/features/apps/application/app_providers.dart';
import 'package:phonemanager/features/apps/view/widgets/usage_access_banner.dart';
import 'package:phonemanager/features/device/application/device_providers.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';
import 'package:phonemanager/ui/load_error.dart';
import 'package:phonemanager/ui/meter.dart';
import 'package:phonemanager/ui/system_screen.dart';
import 'package:phonemanager/ui/theme.dart';

/// Internal storage: used and free space, what fills it, and the ways to free some.
class StorageScreen extends ConsumerWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.storageTool)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(storageStatusProvider);
          await ref.read(sizeReportProvider.notifier).refresh();
        },
        child: switch (ref.watch(storageStatusProvider)) {
          AsyncData(:final value) => _StorageBody(status: value),
          AsyncError(:final error) => Center(
            child: LoadError(error: error, onRetry: () => ref.invalidate(storageStatusProvider)),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _StorageBody extends ConsumerWidget {
  const _StorageBody({required this.status});

  final StorageStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    String bytes(int b) => formatBytes(b, locale: locale);
    final breakdown = status.breakdown;
    final appBytes = ref.watch(totalAppBytesProvider);
    final cacheBytes = ref.watch(totalCacheBytesProvider);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: screenPadding,
      children: [
        if (breakdown == null) const UsageAccessBanner(margin: UsageAccessBanner.inListMargin),
        SectionCard(
          children: [
            Meter(
              headline: l10n.usedOf(bytes(status.usedBytes), bytes(status.totalBytes)),
              fraction: status.usedFraction,
              warn: status.usedFraction >= 0.9,
              caption: l10n.freeSpace(bytes(status.freeBytes)),
            ),
          ],
        ),
        if (breakdown != null)
          SectionCard(
            title: l10n.whatUsesSpace,
            children: [
              if (appBytes != null)
                InfoRow(
                  leading: const Icon(Icons.apps),
                  label: l10n.storageApps,
                  value: bytes(appBytes),
                ),
              InfoRow(
                leading: const Icon(Icons.image_outlined),
                label: l10n.storageImages,
                value: bytes(breakdown.imageBytes),
              ),
              InfoRow(
                leading: const Icon(Icons.movie_outlined),
                label: l10n.storageVideos,
                value: bytes(breakdown.videoBytes),
              ),
              InfoRow(
                leading: const Icon(Icons.music_note_outlined),
                label: l10n.storageAudio,
                value: bytes(breakdown.audioBytes),
              ),
              InfoRow(
                leading: const Icon(Icons.insert_drive_file_outlined),
                label: l10n.storageOtherFiles,
                value: bytes(breakdown.otherFileBytes),
              ),
              if (cacheBytes != null)
                InfoRow(
                  leading: const Icon(Icons.cleaning_services_outlined),
                  label: l10n.storageAppCache,
                  value: bytes(cacheBytes),
                ),
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.storageBreakdownNote, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        SectionCard(
          title: l10n.freeUpSpaceTitle,
          children: [
            Text(l10n.freeUpSpaceBody),
            const SizedBox(height: AppSpacing.md),
            SystemScreenButton(screen: SystemScreen.freeUpSpace, label: l10n.freeUpSpaceButton),
            const SizedBox(height: AppSpacing.sm),
            SystemScreenButton(screen: SystemScreen.storage, label: l10n.storageSettingsButton),
          ],
        ),
      ],
    );
  }
}
