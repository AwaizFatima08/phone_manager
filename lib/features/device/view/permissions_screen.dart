import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/features/apps/application/app_providers.dart';
import 'package:phonemanager/features/apps/view/app_detail_screen.dart';
import 'package:phonemanager/features/apps/view/widgets/app_icon.dart';
import 'package:phonemanager/features/device/application/device_providers.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';
import 'package:phonemanager/features/device/domain/permission_overview.dart';
import 'package:phonemanager/l10n/gen/app_localizations.dart';
import 'package:phonemanager/ui/load_error.dart';
import 'package:phonemanager/ui/meter.dart';
import 'package:phonemanager/ui/system_screen.dart';
import 'package:phonemanager/ui/theme.dart';

/// App permissions across the phone: for each sensitive permission, which apps hold it.
class PermissionsScreen extends ConsumerWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.permissionsTool)),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(permissionOverviewProvider),
        child: switch (ref.watch(permissionOverviewProvider)) {
          AsyncData(:final value) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: screenPadding,
            children: [
              SectionCard(
                children: [
                  Text(l10n.permissionsOverviewBody),
                  const SizedBox(height: AppSpacing.md),
                  SystemScreenButton(screen: SystemScreen.privacy, label: l10n.privacySettings),
                ],
              ),
              if (value.appsByGroup.isEmpty)
                SectionCard(children: [Text(l10n.noGrantedPermissions)]),
              for (final MapEntry(key: group, value: apps) in value.appsByGroup.entries)
                Card(
                  child: ListTile(
                    leading: Icon(groupIcon(group)),
                    title: Text(groupName(l10n, group)),
                    subtitle: Text(l10n.totalsCountOnly(apps.length)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => unawaited(
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => _GroupAppsScreen(group: group, packages: apps),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          AsyncError(:final error) => Center(
            child: LoadError(
              error: error,
              onRetry: () => ref.invalidate(permissionOverviewProvider),
            ),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

/// The apps that hold one permission group; tapping one opens its details and permissions.
class _GroupAppsScreen extends ConsumerWidget {
  const _GroupAppsScreen({required this.group, required this.packages});

  final PermissionGroup group;
  final List<String> packages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final apps = [
      for (final p in packages) ?ref.watch(appByPackageProvider(p)),
    ]..sort((a, b) => a.app.label.toLowerCase().compareTo(b.app.label.toLowerCase()));
    return Scaffold(
      appBar: AppBar(title: Text(groupName(l10n, group))),
      body: ListView(
        padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.sm),
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.md),
            child: Text(l10n.groupAppsBody, style: Theme.of(context).textTheme.bodySmall),
          ),
          for (final e in apps)
            ListTile(
              leading: AppIcon(packageName: e.app.packageName),
              title: Text(e.app.label, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => unawaited(
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AppDetailScreen(packageName: e.app.packageName),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

IconData groupIcon(PermissionGroup g) => switch (g) {
  PermissionGroup.location => Icons.location_on_outlined,
  PermissionGroup.camera => Icons.photo_camera_outlined,
  PermissionGroup.microphone => Icons.mic_none,
  PermissionGroup.contacts => Icons.contacts_outlined,
  PermissionGroup.phone => Icons.phone_outlined,
  PermissionGroup.sms => Icons.sms_outlined,
  PermissionGroup.callLog => Icons.history,
  PermissionGroup.calendar => Icons.calendar_today_outlined,
  PermissionGroup.photosAndMedia => Icons.photo_library_outlined,
  PermissionGroup.files => Icons.folder_outlined,
  PermissionGroup.bodySensors => Icons.monitor_heart_outlined,
  PermissionGroup.physicalActivity => Icons.directions_walk,
  PermissionGroup.nearbyDevices => Icons.bluetooth,
  PermissionGroup.notifications => Icons.notifications_none,
  PermissionGroup.other => Icons.shield_outlined,
};

String groupName(AppLocalizations l10n, PermissionGroup g) => switch (g) {
  PermissionGroup.location => l10n.groupLocation,
  PermissionGroup.camera => l10n.groupCamera,
  PermissionGroup.microphone => l10n.groupMicrophone,
  PermissionGroup.contacts => l10n.groupContacts,
  PermissionGroup.phone => l10n.groupPhone,
  PermissionGroup.sms => l10n.groupSms,
  PermissionGroup.callLog => l10n.groupCallLog,
  PermissionGroup.calendar => l10n.groupCalendar,
  PermissionGroup.photosAndMedia => l10n.groupMedia,
  PermissionGroup.files => l10n.groupFiles,
  PermissionGroup.bodySensors => l10n.groupBodySensors,
  PermissionGroup.physicalActivity => l10n.groupActivity,
  PermissionGroup.nearbyDevices => l10n.groupNearby,
  PermissionGroup.notifications => l10n.groupNotifications,
  PermissionGroup.other => l10n.groupOther,
};
