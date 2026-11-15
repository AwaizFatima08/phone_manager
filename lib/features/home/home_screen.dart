import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/ads/ad_service.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/core/byte_size.dart';
import 'package:phonemanager/features/apps/application/app_providers.dart';
import 'package:phonemanager/features/apps/view/app_list_screen.dart';
import 'package:phonemanager/features/apps/view/widgets/usage_access_banner.dart';
import 'package:phonemanager/features/device/application/device_providers.dart';
import 'package:phonemanager/features/device/domain/permission_overview.dart';
import 'package:phonemanager/features/device/view/cache_screen.dart';
import 'package:phonemanager/features/device/view/memory_screen.dart';
import 'package:phonemanager/features/device/view/permissions_screen.dart';
import 'package:phonemanager/features/device/view/power_screen.dart';
import 'package:phonemanager/features/device/view/storage_screen.dart';
import 'package:phonemanager/ui/overflow_menu.dart';
import 'package:phonemanager/ui/theme.dart';

/// Home: one card per tool, each with a live one-line summary.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final noAccess = ref.watch(sizeReportProvider).value?.hasUsageAccess == false;
    final tools = <_Tool>[
      _Tool(
        Icons.sd_storage_outlined,
        l10n.storageTool,
        _storageSummary(context, ref),
        const StorageScreen(),
      ),
      _Tool(
        Icons.battery_charging_full,
        l10n.powerTool,
        _powerSummary(context, ref),
        const PowerScreen(),
      ),
      _Tool(Icons.apps, l10n.appsTool, _appsSummary(context, ref), const AppListScreen()),
      _Tool(Icons.memory, l10n.memoryTool, _memorySummary(context, ref), const MemoryScreen()),
      _Tool(
        Icons.cleaning_services_outlined,
        l10n.cacheTool,
        _cacheSummary(context, ref),
        const CacheScreen(),
      ),
      _Tool(
        Icons.privacy_tip_outlined,
        l10n.permissionsTool,
        _permissionsSummary(context, ref),
        const PermissionsScreen(),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle), actions: const [OverflowMenu()]),
      body: CustomScrollView(
        slivers: [
          if (noAccess) const SliverToBoxAdapter(child: UsageAccessBanner()),
          SliverPadding(
            padding: const EdgeInsetsDirectional.all(AppSpacing.md),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                mainAxisExtent: 148,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
              ),
              itemCount: tools.length,
              itemBuilder: (context, i) => _ToolCard(tool: tools[i]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(child: ref.watch(adServiceProvider).banner()),
    );
  }

  static String _locale(BuildContext context) => Localizations.localeOf(context).toString();

  static String _storageSummary(BuildContext context, WidgetRef ref) {
    final s = ref.watch(storageStatusProvider).value;
    if (s == null) return '…';
    final locale = _locale(context);
    return context.l10n.freeOf(
      formatBytes(s.freeBytes, locale: locale),
      formatBytes(s.totalBytes, locale: locale),
    );
  }

  static String _powerSummary(BuildContext context, WidgetRef ref) {
    final b = ref.watch(batteryStatusProvider).value;
    if (b == null || b.percent < 0) return '…';
    return b.isCharging
        ? context.l10n.batteryCharging(b.percent)
        : context.l10n.batteryPercent(b.percent);
  }

  static String _appsSummary(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(installedAppsProvider).value;
    if (apps == null) return '…';
    return context.l10n.totalsCountOnly(apps.where((a) => !a.isSystem || a.isUpdatedSystem).length);
  }

  static String _memorySummary(BuildContext context, WidgetRef ref) {
    final m = ref.watch(memoryStatusProvider).value;
    if (m == null) return '…';
    final locale = _locale(context);
    return context.l10n.freeOf(
      formatBytes(m.availableBytes, locale: locale),
      formatBytes(m.totalBytes, locale: locale),
    );
  }

  static String _cacheSummary(BuildContext context, WidgetRef ref) {
    final total = ref.watch(totalCacheBytesProvider);
    if (ref.watch(sizeReportProvider).value?.hasUsageAccess == false) {
      return context.l10n.needsUsageAccess;
    }
    if (total == null) return '…';
    return context.l10n.cacheInApps(formatBytes(total, locale: _locale(context)));
  }

  static String _permissionsSummary(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(permissionOverviewProvider).value;
    if (overview == null) return '…';
    final location = overview.appsWith(PermissionGroup.location).length;
    return context.l10n.appsWithLocation(location);
  }
}

class _Tool {
  const _Tool(this.icon, this.title, this.summary, this.screen);

  final IconData icon;
  final String title;
  final String summary;
  final Widget screen;
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.tool});

  final _Tool tool;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsetsDirectional.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => unawaited(
          Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => tool.screen)),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(tool.icon, size: 32, color: theme.colorScheme.primary),
              const Spacer(),
              Text(tool.title, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                tool.summary,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
