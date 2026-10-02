import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme_tokens.dart';

/// Input and divider styles shared by app forms and layouts.
abstract final class AppThemeInput {
  static ThemeData apply(ThemeData base, {required bool isDark}) {
    final scheme = base.colorScheme;
    final text = base.textTheme;
    return base.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkMuted : AppColors.muted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.md,
        ),
        hintStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        labelStyle: text.bodyMedium,
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(
          color: isDark ? AppColors.darkPrimary : AppColors.primary,
          width: 1.5,
        ),
        errorBorder: _border(color: AppColors.destructive),
        focusedErrorBorder: _border(color: AppColors.destructive, width: 1.5),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static OutlineInputBorder _border({Color? color, double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: color == null
            ? BorderSide.none
            : BorderSide(color: color, width: width),
      );
}
