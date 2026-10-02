import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';

/// Tab and primary navigation styles.
abstract final class AppThemeNavigation {
  static ThemeData apply(
    ThemeData base, {
    required bool isDark,
    required TextTheme textTheme,
  }) {
    final active = isDark ? AppColors.darkPrimary : AppColors.primary;
    final inactive = isDark
        ? AppColors.darkMutedForeground
        : AppColors.mutedForeground;
    return base.copyWith(
      tabBarTheme: TabBarThemeData(
        indicatorColor: active,
        labelColor: isDark ? AppColors.darkForeground : AppColors.foreground,
        unselectedLabelColor: inactive,
        dividerColor: Colors.transparent,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.card,
        indicatorColor: active.withValues(alpha: 0.12),
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: states.contains(WidgetState.selected) ? 26 : 24,
            color: states.contains(WidgetState.selected) ? active : inactive,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? active : inactive,
          ),
        ),
      ),
    );
  }
}
