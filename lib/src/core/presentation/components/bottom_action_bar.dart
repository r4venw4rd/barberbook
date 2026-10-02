import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Fixed bottom action bar with safe-area clearance and frosted glass blur.
/// Scroll views that use it must add matching bottom padding so content is
/// visible as it flows underneath.
class BottomActionBar extends StatelessWidget {
  /// Creates a bottom action bar.
  const new({required this.child, super.key, this.leading});

  /// Primary actions, usually a full-width button.
  final Widget child;

  /// Optional content rendered above [child], for example a price summary.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final glassFill = isDark
        ? AppColors.darkCard.withValues(alpha: 0.82)
        : AppColors.card.withValues(alpha: 0.88);
    final topBorder = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.border.withValues(alpha: 0.60);

    return ClipRect(
      child: BackdropFilter(
        filter: reduceMotion
            ? ImageFilter.blur()
            : ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppSpace.lg,
            AppSpace.lg,
            AppSpace.lg,
            AppSpace.sm + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: glassFill,
            border: Border(top: BorderSide(color: topBorder, width: 0.75)),
            boxShadow: isDark
                ? null
                : const [
                    BoxShadow(
                      color: AppColors.shadowBar,
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    ),
                  ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(height: AppSpace.md),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
