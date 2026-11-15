import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/features/apps/data/app_repository.dart';
import 'package:phonemanager/ui/theme.dart';

/// Explains why sizes are missing and opens Android's Usage access page.
class UsageAccessBanner extends ConsumerWidget {
  const UsageAccessBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsetsDirectional.fromSTEB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.sm,
        ),
        child: Row(
          children: [
            const Icon(Icons.data_usage),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.usageAccessTitle, style: theme.textTheme.titleSmall),
                  Text(l10n.usageAccessBody, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            TextButton(
              onPressed: () => openUsageAccess(context, ref),
              child: Text(l10n.usageAccessButton),
            ),
          ],
        ),
      ),
    );
  }
}

/// Opens Usage access; tells the user when the phone has no such screen.
Future<void> openUsageAccess(BuildContext context, WidgetRef ref) async {
  final opened = await ref.read(appRepositoryProvider).openUsageAccessSettings();
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.settingsUnavailable)),
    );
  }
}
