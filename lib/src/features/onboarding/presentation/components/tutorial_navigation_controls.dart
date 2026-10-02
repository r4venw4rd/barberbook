import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/presentation/components/primary_button.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Top brand row and optional skip action.
class TutorialHeader extends StatelessWidget {
  const new({required this.showSkip, required this.onSkip, super.key});

  final bool showSkip;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentStrong;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.lg,
        vertical: AppSpace.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
              ),
              const SizedBox(width: AppSpace.sm),
              Text(
                'BARBERBOOK',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 2.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (showSkip)
            TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.md,
                  vertical: AppSpace.xs,
                ),
              ),
              child: const Text('Skip'),
            )
          else
            const SizedBox(height: 38),
        ],
      ),
    );
  }
}

/// Slide indicator and primary next/finish action.
class TutorialFooter extends StatelessWidget {
  const new({
    required this.currentIndex,
    required this.itemCount,
    required this.isLastSlide,
    required this.onContinue,
    super.key,
  });

  final int currentIndex;
  final int itemCount;
  final bool isLastSlide;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentStrong;
    final isDark = context.isDarkTheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.xl,
        AppSpace.md,
        AppSpace.xl,
        AppSpace.xxl,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              itemCount,
              (index) => _PageIndicator(
                selected: index == currentIndex,
                accent: accent,
                inactive: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: PrimaryButton(
              onPressed: onContinue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastSlide ? 'Get Started' : 'Continue',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpace.sm),
                  Icon(
                    isLastSlide
                        ? Icons.arrow_forward_rounded
                        : Icons.chevron_right_rounded,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const new({required this.selected, required this.accent, required this.inactive});

  final bool selected;
  final Color accent;
  final Color inactive;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 280),
    curve: Curves.easeOutCubic,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: selected ? 30 : 8,
    height: 8,
    decoration: BoxDecoration(
      color: selected ? accent : inactive,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      boxShadow: selected
          ? [BoxShadow(color: accent.withValues(alpha: 0.40), blurRadius: 8)]
          : null,
    ),
  );
}
