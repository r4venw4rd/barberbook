import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/presentation/components/initials_avatar.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Adaptive avatar component with network photo support and initials fallback.
class AppAvatar extends StatelessWidget {
  /// Creates an adaptive avatar.
  const new({
    required this.initials,
    required this.color,
    this.avatarUrl,
    this.size = 48,
    this.showBadge = false,
    this.badgeColor,
    super.key,
  });

  /// Optional network portrait URL.
  final String? avatarUrl;

  /// Initials string for fallback rendering.
  final String initials;

  /// Theme accent colour for the fallback gradient.
  final Color color;

  /// Diameter of the avatar.
  final double size;

  /// Whether to show the bottom-right status indicator badge.
  final bool showBadge;

  /// Custom badge indicator colour.
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final hasUrl = avatarUrl != null && avatarUrl!.trim().isNotEmpty;
    final isDark = context.isDarkTheme;

    final fallback = InitialsAvatar(
      initials: initials,
      color: color,
      size: size,
    );

    final avatar = hasUrl
        ? Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isDark ? Border.all(color: context.borderSurface) : null,
            ),
            child: ClipOval(
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (context, error, stackTrace) => fallback,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return fallback;
                },
              ),
            ),
          )
        : fallback;

    if (!showBadge) return avatar;

    final dotSize = (size * 0.26).clamp(10.0, 16.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: badgeColor ?? context.successText,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.cardSurface,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
