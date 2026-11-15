import 'package:flutter/material.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/core/result.dart';
import 'package:phonemanager/ui/theme.dart';

/// "Could not read …" with a Try again button.
class LoadError extends StatelessWidget {
  const LoadError({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final code = error is Failure ? (error as Failure).code : '$error';
    return Padding(
      padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.readError(code), textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
