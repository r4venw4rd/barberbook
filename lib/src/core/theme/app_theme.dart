import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hair_dryer_app/src/core/theme/app_colors.dart';

/// Spacing scale (4/8 rhythm).
abstract final class AppSpace {
  /// Extra small gap — 4dp.
  static const double xs = 4;

  /// Small gap — 8dp.
  static const double sm = 8;

  /// Medium gap — 12dp.
  static const double md = 12;

  /// Large gap — 16dp (default page gutter on mobile).
  static const double lg = 16;

  /// Extra large gap — 24dp.
  static const double xl = 24;

  /// Double extra large gap — 32dp.
  static const double xxl = 32;

  /// Triple extra large gap — 48dp.
  static const double xxxl = 48;
}

/// Corner radii.
abstract final class AppRadius {
  /// Small radius — 8dp.
  static const double sm = 8;

  /// Medium radius — 12dp.
  static const double md = 12;

  /// Large radius — 16dp.
  static const double lg = 16;

  /// Extra large radius — 20dp.
  static const double xl = 20;

  /// Double extra large radius — 28dp.
  static const double xxl = 28;

  /// Fully rounded (pill) radius.
  static const double pill = 999;
}

/// Typography ratios that keep scaled text driven by design tokens rather
/// than by magic numbers inside widgets.
abstract final class AppTypeScale {
  /// Avatar initials occupy this fraction of the avatar box size.
  static const double avatarText = 0.34;
}

/// Minimum touch target (44pt iOS / 48dp Android).
const double kTouchTarget = 48;

/// Builds the light and dark [ThemeData] for the app.
abstract final class AppTheme {
  /// Cached light theme.
  static final ThemeData lightTheme = _build(Brightness.light);

  /// Cached dark theme.
  static final ThemeData darkTheme = _build(Brightness.dark);

  /// Light theme.
  static ThemeData light() => lightTheme;

  /// Dark theme.
  static ThemeData dark() => darkTheme;

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
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

    final baseText = isDark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;

    // google_fonts exposes TextStyle only; TextTheme is constructed here so it
    // matches Flutter's own TextTheme type.
    TextStyle fontFrom(TextStyle? style) =>
        GoogleFonts.plusJakartaSans(textStyle: style);

    final textTheme =
        TextTheme(
          displayLarge: fontFrom(baseText.displayLarge),
          displayMedium: fontFrom(baseText.displayMedium),
          displaySmall: fontFrom(baseText.displaySmall),
          headlineLarge: fontFrom(baseText.headlineLarge),
          headlineMedium: fontFrom(baseText.headlineMedium),
          headlineSmall: fontFrom(baseText.headlineSmall),
          titleLarge: fontFrom(baseText.titleLarge),
          titleMedium: fontFrom(baseText.titleMedium),
          titleSmall: fontFrom(baseText.titleSmall),
          bodyLarge: fontFrom(baseText.bodyLarge),
          bodyMedium: fontFrom(baseText.bodyMedium),
          bodySmall: fontFrom(baseText.bodySmall),
          labelLarge: fontFrom(baseText.labelLarge),
          labelMedium: fontFrom(baseText.labelMedium),
          labelSmall: fontFrom(baseText.labelSmall),
        ).copyWith(
          displaySmall: GoogleFonts.plusJakartaSans(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.10,
            letterSpacing: -1.2,
            color: colorScheme.onSurface,
          ),
          headlineMedium: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.16,
            letterSpacing: -0.8,
            color: colorScheme.onSurface,
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.22,
            letterSpacing: -0.5,
            color: colorScheme.onSurface,
          ),
          titleLarge: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            color: colorScheme.onSurface,
          ),
          titleMedium: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
            color: colorScheme.onSurface,
          ),
          titleSmall: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
            color: colorScheme.onSurface,
          ),
          bodyLarge: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.55,
            color: colorScheme.onSurface,
          ),
          bodyMedium: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.55,
            color: colorScheme.onSurface,
          ),
          bodySmall: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: colorScheme.onSurfaceVariant,
          ),
          labelLarge: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: colorScheme.onSurface,
          ),
          labelMedium: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: colorScheme.onSurfaceVariant,
          ),
          labelSmall: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: colorScheme.onSurfaceVariant,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, kTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.xl,
            vertical: AppSpace.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, kTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.lg,
            vertical: AppSpace.md,
          ),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
          backgroundColor: (isDark ? AppColors.darkCard : AppColors.card)
              .withValues(alpha: 0.8),
          surfaceTintColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, kTouchTarget),
          foregroundColor: colorScheme.onSurfaceVariant,
          textStyle: textTheme.titleSmall,
          overlayColor: colorScheme.primary.withValues(alpha: 0.10),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkMuted : AppColors.muted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.destructive,
            width: 1.5,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.border,
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: isDark
            ? AppColors.darkPrimary
            : AppColors.primaryStrong,
        labelColor: isDark ? AppColors.darkForeground : AppColors.foreground,
        unselectedLabelColor: isDark
            ? AppColors.darkMutedForeground
            : AppColors.mutedForeground,
        dividerColor: Colors.transparent,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.card,
        indicatorColor: (isDark
                ? AppColors.darkPrimary
                : AppColors.primary)
            .withValues(alpha: 0.12),
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: states.contains(WidgetState.selected) ? 26 : 24,
            color: states.contains(WidgetState.selected)
                ? (isDark ? AppColors.darkPrimary : AppColors.primaryStrong)
                : (isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground),
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? (isDark ? AppColors.darkPrimary : AppColors.primaryStrong)
                : (isDark
                      ? AppColors.darkMutedForeground
                      : AppColors.mutedForeground),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.darkCard : const Color(0xFF0F172A),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isDark ? AppColors.darkPrimary : AppColors.primaryStrong,
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
              ? (isDark ? const Color(0xFF001018) : Colors.white)
              : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? (isDark ? AppColors.darkPrimary : AppColors.primaryStrong)
              : (isDark ? AppColors.darkMuted : const Color(0xFFCBD5E1)),
        ),
      ),
    );
  }
}

/// Palette helpers that resolve light/dark design tokens from a
/// [BuildContext] so widgets never reference raw colour values.
extension ThemeExtras on BuildContext {
  /// Whether the ambient theme is dark.
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  /// Foreground colour for success messaging.
  Color get successText =>
      isDarkTheme ? AppColors.darkSuccessText : AppColors.successText;

  /// Surface colour for success messaging.
  Color get successSurface =>
      isDarkTheme ? AppColors.darkSuccessSurface : AppColors.successSurface;

  /// Foreground colour for warning messaging.
  Color get warningText =>
      isDarkTheme ? AppColors.darkWarningText : AppColors.warningText;

  /// Surface colour for warning messaging.
  Color get warningSurface =>
      isDarkTheme ? AppColors.darkWarningSurface : AppColors.warningSurface;

  /// Foreground colour for destructive actions.
  Color get dangerText =>
      isDarkTheme ? AppColors.darkDestructive : AppColors.destructive;

  /// Surface colour for destructive actions.
  Color get dangerSurface => isDarkTheme
      ? AppColors.darkDestructiveSurface
      : AppColors.destructiveSurface;

  /// Card surface colour.
  Color get cardSurface => isDarkTheme ? AppColors.darkCard : AppColors.card;

  /// Slightly elevated card surface (for nested surfaces in dark mode).
  Color get cardElevatedSurface =>
      isDarkTheme ? AppColors.darkCardElevated : AppColors.muted;

  /// Muted surface colour.
  Color get mutedSurface => isDarkTheme ? AppColors.darkMuted : AppColors.muted;

  /// Border colour for surfaces.
  Color get borderSurface =>
      isDarkTheme ? AppColors.darkBorder : AppColors.border;

  /// Strong accent colour used for selection, focus and progress.
  Color get accentStrong =>
      isDarkTheme ? AppColors.darkPrimary : AppColors.primary;

  /// Accent colour at low alpha, used for tinted selection backgrounds.
  Color get accentTint => accentStrong.withValues(alpha: 0.12);

  /// Gold glow for selected or highlighted premium surfaces.
  Color get goldGlow => accentStrong.withValues(alpha: 0.18);
}
