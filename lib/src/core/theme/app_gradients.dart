import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';

/// Gradient tokens shared by app surfaces and controls.
abstract final class AppGradients {
  /// Hero gradient in light mode: elegant warm champagne porcelain.
  static const lightHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFBF5), Color(0xFFFAF4EA), Color(0xFFF4ECE0)],
  );

  /// Hero gradient: Cinematic Obsidian with subtle warm undertone.
  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1F28),
      Color(0xFF161820),
      Color(0xFF111318),
      Color(0xFF0D0F15),
    ],
    stops: [0.0, 0.35, 0.70, 1.0],
  );

  /// Gold accent shimmer — diagonal overlay on the hero card.
  static const goldShimmerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x1AE5A93C), Color(0x06E5A93C), Color(0x00E5A93C)],
    stops: [0.0, 0.45, 1.0],
  );

  /// Primary button fill in light mode — luminous warm gold.
  static const primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD4952B), Color(0xFFB57518)],
  );

  /// Primary button fill in dark mode — deep cognac amber gold.
  static const darkPrimaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFB8781E), Color(0xFF754508)],
  );

  /// Offer banner gradient in light mode — soft champagne porcelain.
  static const lightOfferGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFAF7F2), Color(0xFFF4EDE2)],
  );

  /// Offer banner gradient in dark mode.
  static const darkOfferGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.darkCardElevated, AppColors.darkCard],
  );

  /// Service summary bar gradient in light mode.
  static const lightSummaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFAF6EE), Color(0xFFF3ECE0)],
  );

  /// Service summary bar gradient in dark mode.
  static const darkSummaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x38B8781E), Color(0x1F754508)],
  );

  /// Glossy sheen over the top half of primary buttons, fading to clear.
  static const buttonSheenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.center,
    colors: [Color(0x33FFFFFF), Color(0x00FFFFFF)],
  );
}
