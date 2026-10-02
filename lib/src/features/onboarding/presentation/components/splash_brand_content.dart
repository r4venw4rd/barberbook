import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/snipping_scissors.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Centered animated brand lockup shown on the splash page.
class SplashBrandContent extends StatelessWidget {
  const new({required this.isDark, required this.accent, super.key});

  final bool isDark;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SplashEmblem(isDark: isDark, accent: accent),
        const SizedBox(height: AppSpace.xxl),
        Text(
          'BARBERBOOK',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 4.5,
            color: isDark ? Colors.white : AppColors.foreground,
          ),
        ),
        const SizedBox(height: AppSpace.sm),
        _Tagline(accent: accent),
        const SizedBox(height: AppSpace.xxxl),
        SizedBox(
          width: 38,
          height: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              backgroundColor: accent.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
        ),
      ],
    );
  }
}

class _SplashEmblem extends StatelessWidget {
  const new({required this.isDark, required this.accent});

  final bool isDark;
  final Color accent;

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              accent.withValues(alpha: isDark ? 0.32 : 0.20),
              accent.withValues(alpha: 0),
            ],
          ),
        ),
      ),
      Container(
        width: 108,
        height: 108,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppColors.darkCardElevated : Colors.white,
          border: Border.all(color: accent.withValues(alpha: 0.50), width: 2),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.24),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: SnippingScissors(
            size: 72,
            color: accent,
            pivotColor: isDark ? AppColors.darkSecondary : AppColors.primaryStrong,
          ),
        ),
      ),
    ],
  );
}

class _Tagline extends StatelessWidget {
  const new({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpace.md,
      vertical: AppSpace.xs,
    ),
    decoration: BoxDecoration(
      color: accent.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      border: Border.all(color: accent.withValues(alpha: 0.26)),
    ),
    child: Text(
      'ARTISAN GROOMING & LOUNGE',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        letterSpacing: 2.2,
        fontWeight: FontWeight.w700,
        fontSize: 9.5,
        color: accent,
      ),
    ),
  );
}
