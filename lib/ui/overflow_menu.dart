import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/ads/ad_service.dart';
import 'package:phonemanager/app.dart';

/// The home screen's menu: privacy choices (where the law asks for them) and About.
enum _MenuItem { privacy, about }

class OverflowMenu extends ConsumerWidget {
  const OverflowMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final showPrivacy = ref.watch(privacyChoicesRequiredProvider).value ?? false;
    return PopupMenuButton<_MenuItem>(
      onSelected: (item) => unawaited(_select(context, ref, item)),
      itemBuilder: (context) => [
        if (showPrivacy) PopupMenuItem(value: _MenuItem.privacy, child: Text(l10n.privacyChoices)),
        PopupMenuItem(value: _MenuItem.about, child: Text(l10n.about)),
      ],
    );
  }

  Future<void> _select(BuildContext context, WidgetRef ref, _MenuItem item) async {
    switch (item) {
      case _MenuItem.privacy:
        await ref.read(adServiceProvider).showPrivacyChoices();
      case _MenuItem.about:
        showAboutDialog(
          context: context,
          applicationName: context.l10n.appTitle,
          applicationLegalese: '© HomiLabs',
          children: [Text(context.l10n.aboutBody)],
        );
    }
  }
}
