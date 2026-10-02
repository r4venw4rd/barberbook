import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// A premium frosted-glass app bar that blurs content scrolling beneath it.
class FrostedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const new({
    required this.title,
    super.key,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.blur = 20.0,
    this.bottom,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final double blur;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final isDark = context.isDarkTheme;

    final glassFill = isDark
        ? AppColors.darkBackground.withValues(alpha: 0.72)
        : AppColors.background.withValues(alpha: 0.78);
    final bottomBorder = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.border.withValues(alpha: 0.60);

    return ClipRect(
      child: BackdropFilter(
        filter: reduceMotion
            ? ImageFilter.blur()
            : ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: glassFill,
            border: Border(
              bottom: BorderSide(color: bottomBorder, width: 0.75),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: leading,
            title: title,
            actions: actions,
            centerTitle: centerTitle,
            bottom: bottom,
          ),
        ),
      ),
    );
  }
}

/// A frosted glass container that applies backdrop blur and semi-transparent
/// surface styling behind its [child].
class FrostedContainer extends StatelessWidget {
  const new({
    required this.child,
    super.key,
    this.blur = 20.0,
    this.showTopBorder = false,
    this.showBottomBorder = true,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final double blur;
  final bool showTopBorder;
  final bool showBottomBorder;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final isDark = context.isDarkTheme;

    final glassFill = isDark
        ? AppColors.darkBackground.withValues(alpha: 0.75)
        : AppColors.background.withValues(alpha: 0.80);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.border.withValues(alpha: 0.60);

    final border = Border(
      top: showTopBorder
          ? BorderSide(color: borderColor, width: 0.75)
          : BorderSide.none,
      bottom: showBottomBorder
          ? BorderSide(color: borderColor, width: 0.75)
          : BorderSide.none,
    );

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: glassFill,
        borderRadius: borderRadius,
        border: borderRadius == null
            ? border
            : Border.all(color: borderColor, width: 0.75),
      ),
      child: child,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: BackdropFilter(
          filter: reduceMotion
              ? ImageFilter.blur()
              : ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: content,
        ),
      );
    }

    return ClipRect(
      child: BackdropFilter(
        filter: reduceMotion
            ? ImageFilter.blur()
            : ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      ),
    );
  }
}
