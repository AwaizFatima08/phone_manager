import 'package:flutter/material.dart';

/// Design tokens: deep indigo chrome with one amber accent for warnings and
/// the cache figures.
abstract final class AppColors {
  static const brand = Color(0xFF23357A);
  static const amber = Color(0xFFB86E00);
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: brightness == Brightness.light ? AppColors.brand : scheme.surface,
        foregroundColor: brightness == Brightness.light ? Colors.white : scheme.onSurface,
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      ),
    );
  }
}
