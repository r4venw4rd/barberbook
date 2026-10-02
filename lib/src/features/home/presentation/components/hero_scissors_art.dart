import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_gradients.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/snipping_scissors.dart';

/// Decorative scissor artwork and shimmer overlay for the hero card.
class HeroScissorsArt extends StatelessWidget {
  const new({
    required this.isDark,
    required this.accent,
    super.key,
  });

  final bool isDark;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          if (isDark)
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppGradients.goldShimmerGradient,
                ),
              ),
            ),
          Positioned(
            right: -20,
            top: -12,
            child: Transform.rotate(
              angle: -0.42,
              child: SnippingScissors(
                size: 200,
                color: accent.withValues(alpha: isDark ? 0.10 : 0.12),
                pivotColor: accent.withValues(alpha: isDark ? 0.55 : 0.40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
