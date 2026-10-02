import 'package:flutter/material.dart';

import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Initials avatar — vector-only, no raster assets needed.
class InitialsAvatar extends StatelessWidget {
  /// Creates an initials avatar.
  const new({
    required this.initials,
    required this.color,
    super.key,
    this.size = 48,
  });

  /// One or two letters rendered inside the avatar.
  final String initials;

  /// Brand colour of the person this avatar represents.
  final Color color;

  /// Edge length of the square avatar box.
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, AppColors.avatarShade, 0.25)!],
        ),
        border: isDark ? Border.all(color: context.borderSurface) : null,
      ),
      child: Text(
        initials,
        style: textTheme.titleMedium?.copyWith(
          color: AppColors.onAvatar,
          fontWeight: FontWeight.w800,
          fontSize: size * AppTypeScale.avatarText,
        ),
      ),
    );
  }
}
