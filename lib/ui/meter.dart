import 'package:flutter/material.dart';
import 'package:phonemanager/ui/theme.dart';

/// A headline figure over a used/total bar, e.g. storage or memory in use.
class Meter extends StatelessWidget {
  const Meter({
    required this.headline,
    required this.fraction,
    this.caption,
    this.warn = false,
    super.key,
  });

  final String headline;

  /// 0–1, clamped.
  final double fraction;
  final String? caption;

  /// Paints the bar in the warning colour (nearly full, hot, low memory).
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headline, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          child: LinearProgressIndicator(
            value: fraction.clamp(0, 1),
            minHeight: 10,
            color: warn ? AppColors.amber : null,
          ),
        ),
        if (caption case final caption?) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(caption, style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }
}

/// A titled card section with padding, used by every tool screen.
class SectionCard extends StatelessWidget {
  const SectionCard({required this.children, this.title, super.key});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title case final title?) ...[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
          ],
          ...children,
        ],
      ),
    ),
  );
}

/// A label on the start side and its value on the end side.
class InfoRow extends StatelessWidget {
  const InfoRow({required this.label, required this.value, this.leading, super.key});

  final String label;
  final String value;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.xs),
    child: Row(
      children: [
        if (leading case final leading?) ...[leading, const SizedBox(width: AppSpacing.sm)],
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.labelLarge),
      ],
    ),
  );
}

/// The padding every tool screen's list uses.
const screenPadding = EdgeInsetsDirectional.fromSTEB(
  AppSpacing.md,
  AppSpacing.sm,
  AppSpacing.md,
  AppSpacing.lg,
);
