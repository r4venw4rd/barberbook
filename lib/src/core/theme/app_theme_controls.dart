import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme_tokens.dart';

/// Snackbar, progress, list tile, and switch styles.
abstract final class AppThemeControls {
  static ThemeData apply(ThemeData base, {required bool isDark}) =>
      base.copyWith(
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isDark ? AppColors.darkCard : AppColors.foreground,
          contentTextStyle: base.textTheme.bodyMedium?.copyWith(
            color: AppColors.onPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: isDark ? AppColors.darkPrimary : AppColors.primary,
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          iconColor: isDark ? AppColors.darkMutedForeground : null,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? (isDark ? AppColors.darkBackground : AppColors.onPrimary)
                : null,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                : (isDark ? AppColors.darkMuted : AppColors.border),
          ),
        ),
      );
}
