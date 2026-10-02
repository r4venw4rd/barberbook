import 'package:flutter/material.dart';

/// Design tokens for BarberBook calibrated via modern Color Theory.
///
/// Palette Structure:
/// - 60% Canvas & Structure: Warm Porcelain / Velvet Obsidian
/// - 30% Elevated Surfaces: Crisp White & Dark Charcoal Cards
/// - 10% Radiant Brand Accent: Champagne Gold & Cognac Amber
/// - Split-Complementary Indicators: Subtle Emerald Dot for Confirmed Status
abstract final class AppColors {
  // Brand / Accents (Champagne Gold & Cognac Amber)

  /// Warm Champagne Gold brand colour in light mode.
  static const primary = Color(0xFFC78B2A);

  /// Solid deep amber gold for strong fills and accents.
  static const primaryStrong = Color(0xFFA66E19);

  /// Pressed state of [primary].
  static const primaryPressed = Color(0xFF8F580E);

  /// Secondary champagne gold highlight colour.
  static const secondary = Color(0xFFD4952B);

  /// Split-complementary positive/verified colour (Emerald 500).
  static const accent = Color(0xFF10B981);

  // Light surfaces (Clean Warm Porcelain foundation)

  /// App background in light mode (Warm Porcelain).
  static const background = Color(0xFFF7F7F9);

  /// Card background in light mode (Pure White).
  static const card = Color(0xFFFFFFFF);

  /// Muted panel background in light mode (Soft Warm Slate).
  static const muted = Color(0xFFF0F1F4);

  /// Hairline border in light mode (Fine Platinum).
  static const border = Color(0xFFE2E4E8);

  // Light text (High-contrast luxury neutrals)

  /// Primary text colour in light mode (Rich Obsidian).
  static const foreground = Color(0xFF0F1117);

  /// Secondary text colour in light mode (Warm Slate, WCAG 4.5:1+ compliant).
  static const mutedForeground = Color(0xFF64748B);

  /// Text/icon colour drawn on top of [primary].
  static const onPrimary = Color(0xFFFFFFFF);

  // Status (Triadic / Split-Complement Harmony)

  /// Success foreground (Emerald 600).
  static const successText = Color(0xFF059669);

  /// Success panel background (Soft Mint Neutral).
  static const successSurface = Color(0xFFF0FDF4);

  /// Warning foreground (Amber 600).
  static const warningText = Color(0xFFD97706);

  /// Warning panel background (Amber Neutral).
  static const warningSurface = Color(0xFFFFFBEB);

  /// Destructive foreground (Rose/Red 500).
  static const destructive = Color(0xFFEF4444);

  /// Destructive panel background (Rose Neutral).
  static const destructiveSurface = Color(0xFFFEF2F2);

  /// Text/icon colour drawn on top of [destructive].
  static const onDestructive = Color(0xFFFFFFFF);

  // Dark surfaces (Velvet Obsidian & Deep Charcoal)

  /// App background in dark mode (Deep Obsidian).
  static const darkBackground = Color(0xFF09090C);

  /// Card background in dark mode (Elevated Charcoal).
  static const darkCard = Color(0xFF111318);

  /// Slightly elevated card in dark mode (for nested surfaces).
  static const darkCardElevated = Color(0xFF191C23);

  /// Muted panel background in dark mode.
  static const darkMuted = Color(0xFF1A1D25);

  /// Hairline border in dark mode (Subtle Charcoal Border).
  static const darkBorder = Color(0xFF252830);

  // Dark text

  /// Primary text colour in dark mode (98% Lightness).
  static const darkForeground = Color(0xFFF8FAFC);

  /// Secondary text colour in dark mode (Slate 400).
  static const darkMutedForeground = Color(0xFF94A3B8);

  /// Interactive radiant champagne in dark mode.
  static const darkPrimary = Color(0xFFE5A93C);

  /// Secondary accent in dark mode (Champagne Light).
  static const darkSecondary = Color(0xFFF3C76F);

  /// Dark mode on-primary text (Deep Obsidian).
  static const darkOnPrimary = Color(0xFF09090C);

  /// Success foreground in dark mode (Emerald 400).
  static const darkSuccessText = Color(0xFF34D399);

  /// Success panel background in dark mode.
  static const darkSuccessSurface = Color(0xFF064E3B);

  /// Warning foreground in dark mode.
  static const darkWarningText = Color(0xFFFBBF24);

  /// Warning panel background in dark mode.
  static const darkWarningSurface = Color(0xFF451A03);

  /// Destructive foreground in dark mode (Rose 400).
  static const darkDestructive = Color(0xFFF87171);

  /// Destructive panel background in dark mode.
  static const darkDestructiveSurface = Color(0xFF450A0A);

  // Branded / Coloured surfaces

  /// Text drawn on top of the hero gradient.
  static const onHero = Color(0xFFFFFFFF);

  /// Initials drawn on top of an avatar gradient.
  static const onAvatar = Color(0xFFFFFFFF);

  /// Dark end of the avatar gradient.
  static const avatarShade = Color(0xFF000000);

  /// Fully transparent fill.
  static const clear = Color(0x00000000);

  /// Star glyph colour of a rating badge.
  static const ratingStar = Color(0xFFF59E0B);

  /// Unselected time-slot chip fill in dark mode.
  static const slotDark = Color(0xFF1A1D25);

  /// Unselected time-slot chip fill in light mode.
  static const slotLight = Color(0xFFF0F1F3);

  /// Slot unavailable fill in dark mode.
  static const darkSlotUnavailable = Color(0xFF161F33);

  /// Slot unavailable fill in light mode.
  static const lightSlotUnavailable = Color(0xFFF1F5F9);

  /// Ticket card coupon background in dark mode.
  static const darkTicketCoupon = Color(0xFF1E293B);

  /// Ticket card coupon background in light mode.
  static const lightTicketCoupon = Color(0xFFEFF6FF);

  /// Shimmer base and highlight in light mode.
  static const lightShimmerBase = Color(0xFFE8EAEF);
  static const lightShimmerHighlight = Color(0xFFF6F7F9);

  /// Shimmer base and highlight in dark mode.
  static const darkShimmerBase = Color(0xFF191C23);
  static const darkShimmerHighlight = Color(0xFF282C38);

  /// Muted outline.
  static const outlineMuted = Color(0xFF374151);

  // Elevation

  /// Shadow colour of soft cards (light mode — subtle warm shadow).
  static const shadowCard = Color(0x0A000000);

  /// Deeper shadow for premium card elevation (used on service/barber cards).
  static const shadowCardDeep = Color(0x14000000);

  /// Shadow colour of bottom action bars.
  static const shadowBar = Color(0x0E000000);

  /// Coloured glow under primary buttons (light — warm amber gold).
  static const shadowPrimary = Color(0x38C78B2A);

  /// Coloured glow under primary buttons (dark — warm deep amber).
  static const darkShadowPrimary = Color(0x388C5C13);

  /// Gold glow used for selected states and premium highlights.
  static const goldGlow = Color(0x26C78B2A);

  /// Gold shimmer overlay drawn on hero surfaces.
  static const goldShimmer = Color(0x0CE5A93C);

}
