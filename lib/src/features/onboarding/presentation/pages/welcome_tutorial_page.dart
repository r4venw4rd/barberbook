import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_background_pattern.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/onboarding/application/notifiers/onboarding_notifier.dart';
import 'package:hair_dryer_app/src/features/onboarding/presentation/components/tutorial_navigation_controls.dart';
import 'package:hair_dryer_app/src/features/onboarding/presentation/components/tutorial_slide_content.dart';
import 'package:hair_dryer_app/src/features/onboarding/presentation/components/tutorial_slide_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Introduces first-time users to the app's signature barbershop experience.
class WelcomeTutorialPage extends HookConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentIndex = useState(0);
    final isDark = context.isDarkTheme;
    final isLastSlide = currentIndex.value == tutorialSlides.length - 1;

    Future<void> finishOnboarding() async {
      unawaited(HapticFeedback.mediumImpact());
      await ref.read(onboardingCompletedProvider.notifier).completeOnboarding();
      if (!context.mounted) return;
      context.go('/auth');
    }

    void nextPage() {
      unawaited(HapticFeedback.lightImpact());
      if (isLastSlide) {
        unawaited(finishOnboarding());
        return;
      }
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AppBackgroundPattern(
        child: SafeArea(
          child: Column(
            children: [
              TutorialHeader(
                showSkip: !isLastSlide,
                onSkip: finishOnboarding,
              ),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: tutorialSlides.length,
                  onPageChanged: (index) => currentIndex.value = index,
                  itemBuilder: (context, index) => TutorialSlideContent(
                    slide: tutorialSlides[index],
                    isDark: isDark,
                  ),
                ),
              ),
              TutorialFooter(
                currentIndex: currentIndex.value,
                itemCount: tutorialSlides.length,
                isLastSlide: isLastSlide,
                onContinue: nextPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
