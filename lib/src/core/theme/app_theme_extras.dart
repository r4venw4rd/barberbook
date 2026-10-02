import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_gradients.dart';

/// Palette helpers that resolve light/dark design tokens from a context.
extension ThemeExtras on BuildContext {
  /// Whether the ambient theme is dark.
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  /// Foreground and surface colours for status messaging.
  Color get successText =>
      isDarkTheme ? AppColors.darkSuccessText : AppColors.successText;
  Color get successSurface =>
      isDarkTheme ? AppColors.darkSuccessSurface : AppColors.successSurface;
  Color get warningText =>
      isDarkTheme ? AppColors.darkWarningText : AppColors.warningText;
  Color get warningSurface =>
      isDarkTheme ? AppColors.darkWarningSurface : AppColors.warningSurface;
  Color get dangerText =>
      isDarkTheme ? AppColors.darkDestructive : AppColors.destructive;
  Color get dangerSurface => isDarkTheme
      ? AppColors.darkDestructiveSurface
      : AppColors.destructiveSurface;

  /// Surface colours for cards, panels, and borders.
  Color get cardSurface => isDarkTheme ? AppColors.darkCard : AppColors.card;
  Color get cardElevatedSurface =>
      isDarkTheme ? AppColors.darkCardElevated : AppColors.card;
  Color get mutedSurface => isDarkTheme ? AppColors.darkMuted : AppColors.muted;
  Color get borderSurface =>
      isDarkTheme ? AppColors.darkBorder : AppColors.border;

  /// Brand colours and gradients for interactive states.
  Color get accentStrong =>
      isDarkTheme ? AppColors.darkPrimary : AppColors.primary;
  Color get accentTint => accentStrong.withValues(alpha: isDarkTheme ? 0.12 : 0.08);
  Color get goldGlow => accentStrong.withValues(alpha: isDarkTheme ? 0.18 : 0.10);
  LinearGradient get primaryGradient =>
      isDarkTheme ? AppGradients.darkPrimaryGradient : AppGradients.primaryGradient;
  Color get primaryShadow =>
      isDarkTheme ? AppColors.darkShadowPrimary : AppColors.shadowPrimary;
  LinearGradient get heroGradient =>
      isDarkTheme ? AppGradients.heroGradient : AppGradients.lightHeroGradient;
  LinearGradient get offerGradient =>
      isDarkTheme ? AppGradients.darkOfferGradient : AppGradients.lightOfferGradient;
  LinearGradient get summaryGradient => isDarkTheme
      ? AppGradients.darkSummaryGradient
      : AppGradients.lightSummaryGradient;

  /// Surfaces for booking slots, tickets, and shimmer placeholders.
  Color get slotSurface => isDarkTheme ? AppColors.slotDark : AppColors.slotLight;
  Color get slotUnavailableSurface => isDarkTheme
      ? AppColors.darkSlotUnavailable
      : AppColors.lightSlotUnavailable;
  Color get ticketCouponSurface =>
      isDarkTheme ? AppColors.darkTicketCoupon : AppColors.lightTicketCoupon;
  Color get shimmerBase =>
      isDarkTheme ? AppColors.darkShimmerBase : AppColors.lightShimmerBase;
  Color get shimmerHighlight => isDarkTheme
      ? AppColors.darkShimmerHighlight
      : AppColors.lightShimmerHighlight;
}
