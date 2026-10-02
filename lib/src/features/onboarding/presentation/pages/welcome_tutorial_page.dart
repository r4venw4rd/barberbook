import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_background_pattern.dart';
import 'package:hair_dryer_app/src/core/presentation/components/primary_button.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/onboarding/application/notifiers/onboarding_notifier.dart';

class _TutorialSlideData {
  const new({
    required this.tag,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String tag;
  final String title;
  final String description;
  final IconData icon;
}

const List<_TutorialSlideData> _slides = [
  _TutorialSlideData(
    tag: 'ARTISAN CRAFT',
    title: 'Master Barbers,\nSignature Cuts',
    description:
        'Experience precision grooming tailored to your style. From razor-sharp skin fades to executive beard detailing.',
    icon: Icons.content_cut_rounded,
  ),
  _TutorialSlideData(
    tag: 'SEAMLESS BOOKING',
    title: 'Reserve Your Chair\nin 60 Seconds',
    description:
        'Browse live barber availability, select your signature services, and lock in your appointment with zero wait time.',
    icon: Icons.calendar_month_rounded,
  ),
  _TutorialSlideData(
    tag: 'VIP EXPERIENCE',
    title: 'The Ultimate\nLounge Retreat',
    description:
        'Indulge in complimentary craft refreshments, hot steam towels, and premium organic styling treatments.',
    icon: Icons.workspace_premium_rounded,
  ),
];

/// A luxury onboarding tutorial carousel that introduces first-time users
/// to the app's signature barbershop experience.
class WelcomeTutorialPage extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<WelcomeTutorialPage> createState() =>
      _WelcomeTutorialPageState();
}

class _WelcomeTutorialPageState extends ConsumerState<WelcomeTutorialPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    unawaited(HapticFeedback.mediumImpact());
    await ref.read(onboardingCompletedProvider.notifier).completeOnboarding();
    if (!mounted) return;
    // Redirect to auth flow, not directly to home
    // Users must authenticate before accessing the app
    context.go('/auth');
  }

  void _nextPage() {
    unawaited(HapticFeedback.lightImpact());
    if (_currentIndex < _slides.length - 1) {
      unawaited(
        _pageController.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        ),
      );
    } else {
      unawaited(_finishOnboarding());
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = context.isDarkTheme;
    final accent = context.accentStrong;
    final isLastSlide = _currentIndex == _slides.length - 1;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: AppBackgroundPattern(
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Skip Action
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.lg,
                  vertical: AppSpace.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand mark
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent,
                          ),
                        ),
                        const SizedBox(width: AppSpace.sm),
                        Text(
                          'BARBERBOOK',
                          style: textTheme.labelSmall?.copyWith(
                            letterSpacing: 2.2,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white70 : AppColors.foreground,
                          ),
                        ),
                      ],
                    ),
                    // Skip button
                    if (!isLastSlide)
                      TextButton(
                        onPressed: _finishOnboarding,
                        style: TextButton.styleFrom(
                          foregroundColor: isDark
                              ? AppColors.darkMutedForeground
                              : AppColors.mutedForeground,
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
              ),

              // Walkthrough Carousel
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpace.xxl,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Radiant Visual Container
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ambient radial glow
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      accent.withValues(
                                        alpha: isDark ? 0.28 : 0.16,
                                      ),
                                      accent.withValues(alpha: 0),
                                    ],
                                  ),
                                ),
                              ),
                              // Glass-morphic outer orb
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isDark
                                        ? [
                                            AppColors.darkCardElevated,
                                            AppColors.darkCard,
                                          ]
                                        : [
                                            Colors.white,
                                            const Color(0xFFF7F5F0),
                                          ],
                                  ),
                                  border: Border.all(
                                    color: accent.withValues(alpha: 0.40),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accent.withValues(alpha: 0.22),
                                      blurRadius: 32,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    slide.icon,
                                    size: 58,
                                    color: accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpace.xxl),

                          // Tag pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpace.md,
                              vertical: AppSpace.xs,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                              border: Border.all(
                                color: accent.withValues(alpha: 0.28),
                              ),
                            ),
                            child: Text(
                              '✦  ${slide.tag}',
                              style: textTheme.labelSmall?.copyWith(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: accent,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpace.md),

                          // Title
                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              letterSpacing: -0.6,
                              color: isDark ? Colors.white : AppColors.foreground,
                            ),
                          ),
                          const SizedBox(height: AppSpace.md),

                          // Description
                          Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                              color: isDark
                                  ? AppColors.darkMutedForeground
                                  : AppColors.mutedForeground,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Navigation & Controls
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.xl,
                  AppSpace.md,
                  AppSpace.xl,
                  AppSpace.xxl,
                ),
                child: Column(
                  children: [
                    // Dynamic animated pill indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == _currentIndex ? 30 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == _currentIndex
                                ? accent
                                : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.border),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            boxShadow: index == _currentIndex
                                ? [
                                    BoxShadow(
                                      color: accent.withValues(alpha: 0.40),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpace.xl),

                    // Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: PrimaryButton(
                        onPressed: _nextPage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLastSlide ? 'Get Started' : 'Continue',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                                color: isDark
                                    ? AppColors.darkOnPrimary
                                    : AppColors.onPrimary,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
