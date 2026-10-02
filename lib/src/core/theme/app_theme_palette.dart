import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';

/// Creates the color scheme and typography shared by all app themes.
abstract final class AppThemePalette {
  static ColorScheme colorScheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ColorScheme(
      brightness: brightness,
      primary: isDark ? AppColors.darkPrimary : AppColors.primary,
      onPrimary: isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
      secondary: isDark ? AppColors.darkSecondary : AppColors.secondary,
      onSecondary: isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
      error: isDark ? AppColors.darkDestructive : AppColors.destructive,
      onError: AppColors.onDestructive,
      surface: isDark ? AppColors.darkBackground : AppColors.background,
      onSurface: isDark ? AppColors.darkForeground : AppColors.foreground,
      surfaceContainerLowest: isDark ? AppColors.darkCard : AppColors.card,
      surfaceContainerLow: isDark ? AppColors.darkCard : AppColors.card,
      surfaceContainer: isDark ? AppColors.darkMuted : AppColors.muted,
      surfaceContainerHigh: isDark ? AppColors.darkMuted : AppColors.muted,
      surfaceContainerHighest: isDark ? AppColors.darkMuted : AppColors.muted,
      outline: isDark ? AppColors.darkBorder : AppColors.border,
      outlineVariant: isDark ? AppColors.darkBorder : AppColors.border,
      onSurfaceVariant: isDark
          ? AppColors.darkMutedForeground
          : AppColors.mutedForeground,
    );
  }

  static TextTheme textTheme(Brightness brightness, ColorScheme scheme) {
    final base = brightness == Brightness.dark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;
    TextStyle font(TextStyle? style) =>
        GoogleFonts.plusJakartaSans(textStyle: style);

    return TextTheme(
      displayLarge: font(base.displayLarge),
      displayMedium: font(base.displayMedium),
      displaySmall: font(base.displaySmall),
      headlineLarge: font(base.headlineLarge),
      headlineMedium: font(base.headlineMedium),
      headlineSmall: font(base.headlineSmall),
      titleLarge: font(base.titleLarge),
      titleMedium: font(base.titleMedium),
      titleSmall: font(base.titleSmall),
      bodyLarge: font(base.bodyLarge),
      bodyMedium: font(base.bodyMedium),
      bodySmall: font(base.bodySmall),
      labelLarge: font(base.labelLarge),
      labelMedium: font(base.labelMedium),
      labelSmall: font(base.labelSmall),
    ).copyWith(
      displaySmall: _style(34, FontWeight.w800, scheme.onSurface,
          height: 1.10, letterSpacing: -1.2),
      headlineMedium: _style(28, FontWeight.w800, scheme.onSurface,
          height: 1.16, letterSpacing: -0.8),
      headlineSmall: _style(22, FontWeight.w700, scheme.onSurface,
          height: 1.22, letterSpacing: -0.5),
      titleLarge: _style(18, FontWeight.w700, scheme.onSurface, letterSpacing: -0.4),
      titleMedium: _style(16, FontWeight.w600, scheme.onSurface, letterSpacing: -0.25),
      titleSmall: _style(14, FontWeight.w600, scheme.onSurface, letterSpacing: -0.1),
      bodyLarge: _style(15, FontWeight.w400, scheme.onSurface, height: 1.55),
      bodyMedium: _style(14, FontWeight.w400, scheme.onSurface, height: 1.55),
      bodySmall: _style(12, FontWeight.w400, scheme.onSurfaceVariant, height: 1.5),
      labelLarge: _style(14, FontWeight.w600, scheme.onSurface, letterSpacing: 0.1),
      labelMedium: _style(12, FontWeight.w600, scheme.onSurfaceVariant, letterSpacing: 0.2),
      labelSmall: _style(11, FontWeight.w600, scheme.onSurfaceVariant, letterSpacing: 0.3),
    );
  }

  static TextStyle _style(
    double size,
    FontWeight weight,
    Color color, {
    double? height,
    double? letterSpacing,
  }) => GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
