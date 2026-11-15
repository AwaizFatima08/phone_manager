import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/features/apps/application/app_providers.dart';
import 'package:phonemanager/features/device/application/device_providers.dart';
import 'package:phonemanager/features/home/home_screen.dart';
import 'package:phonemanager/l10n/gen/app_localizations.dart';
import 'package:phonemanager/ui/theme.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class PhoneManagerApp extends StatelessWidget {
  const PhoneManagerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => context.l10n.appTitle,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const _RefreshOnResume(child: HomeScreen()),
  );
}

/// Re-reads apps, sizes, permissions and phone readings whenever the user comes back from
/// Android's Settings or uninstall dialog, where any of them may have changed.
class _RefreshOnResume extends ConsumerStatefulWidget {
  const _RefreshOnResume({required this.child});

  final Widget child;

  @override
  ConsumerState<_RefreshOnResume> createState() => _RefreshOnResumeState();
}

class _RefreshOnResumeState extends ConsumerState<_RefreshOnResume> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onResume: () => unawaited(_refresh()));
  }

  Future<void> _refresh() async {
    await Future.wait([
      ref.read(installedAppsProvider.notifier).refresh(),
      ref.read(sizeReportProvider.notifier).refresh(),
    ]);
    if (!mounted) return;
    ref
      ..invalidate(appPermissionsProvider)
      ..invalidate(storageStatusProvider)
      ..invalidate(recentUsageProvider)
      ..invalidate(permissionOverviewProvider)
      ..invalidate(ownCacheBytesProvider);
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
