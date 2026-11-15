import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/features/device/data/device_repository.dart';
import 'package:phonemanager/features/device/domain/device_status.dart';

/// Opens one of Android's own pages; tells the user when the phone has no such screen.
Future<void> openSystemScreen(BuildContext context, WidgetRef ref, SystemScreen screen) async {
  final opened = await ref.read(deviceRepositoryProvider).openSystemScreen(screen);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.settingsUnavailable)),
    );
  }
}

/// A full-width outlined button that opens a system page.
class SystemScreenButton extends ConsumerWidget {
  const SystemScreenButton({required this.screen, required this.label, super.key});

  final SystemScreen screen;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: () => openSystemScreen(context, ref, screen),
      icon: const Icon(Icons.open_in_new),
      label: Text(label),
    ),
  );
}
