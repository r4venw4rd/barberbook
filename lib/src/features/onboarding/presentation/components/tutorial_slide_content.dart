import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/onboarding/presentation/components/tutorial_slide_data.dart';

/// Artwork and copy for one onboarding carousel slide.
class TutorialSlideContent extends StatelessWidget {
  const new({
    required this.slide,
    required this.isDark,
    super.key,
  });

  final TutorialSlideData slide;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentStrong;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SlideArtwork(slide: slide, isDark: isDark, accent: accent),
          const SizedBox(height: AppSpace.xxl),
          _SlideTag(tag: slide.tag, accent: accent),
          const SizedBox(height: AppSpace.md),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _SlideArtwork extends StatelessWidget {
  const new({required this.slide, required this.isDark, required this.accent});

  final TutorialSlideData slide;
  final bool isDark;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                accent.withValues(alpha: isDark ? 0.28 : 0.16),
                accent.withValues(alpha: 0),
              ],
            ),
          ),
        ),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [AppColors.darkCardElevated, AppColors.darkCard]
                  : const [AppColors.card, AppColors.background],
            ),
            border: Border.all(color: accent.withValues(alpha: 0.40), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.22),
                blurRadius: 32,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(child: Icon(slide.icon, size: 58, color: accent)),
        ),
      ],
    );
  }
}

class _SlideTag extends StatelessWidget {
  const new({required this.tag, required this.accent});

  final String tag;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.md,
        vertical: AppSpace.xs,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Text(
        '✦  $tag',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 1.5,
          fontWeight: FontWeight.w700,
          fontSize: 10,
          color: accent,
        ),
      ),
    );
  }
}
