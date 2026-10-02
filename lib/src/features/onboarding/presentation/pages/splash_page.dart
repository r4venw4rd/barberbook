import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_background_pattern.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/snipping_scissors.dart';
import 'package:hair_dryer_app/src/features/onboarding/application/notifiers/onboarding_notifier.dart';

/// A luxury splash screen displayed on launch, featuring an animated gold emblem,
/// brand identity typography, and an automatic smooth transition.
class SplashPage extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Auto-navigate after a polished presentation delay
    _navigationTimer = Timer(const Duration(milliseconds: 1700), _navigateNext);
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;
    final hasSeenOnboarding = ref.read(onboardingCompletedProvider);

    // If onboarding not seen, show welcome tutorial
    if (!hasSeenOnboarding) {
      context.go('/welcome');
      return;
    }

    // Resolve the stored session before choosing the destination
    final user = await ref
        .read(authNotifierProvider.future)
        .catchError((Object _) => null);
    if (!mounted) return;

    // Signed out users must authenticate before accessing the app
    context.go(user == null ? '/auth' : '/home');
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = context.isDarkTheme;
    final accent = context.accentStrong;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: AppBackgroundPattern(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Luminous golden emblem
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Radial ambient glow
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
                      // Gold ring container
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.darkCardElevated
                              : Colors.white,
                          border: Border.all(
                            color: accent.withValues(alpha: 0.50),
                            width: 2,
                          ),
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
                            pivotColor: isDark
                                ? AppColors.darkSecondary
                                : AppColors.primaryStrong,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.xxl),
                  // Brand Name
                  Text(
                    'BARBERBOOK',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4.5,
                      color: isDark ? Colors.white : AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: AppSpace.sm),
                  // Tagline pill
                  Container(
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
                      style: textTheme.labelSmall?.copyWith(
                        letterSpacing: 2.2,
                        fontWeight: FontWeight.w700,
                        fontSize: 9.5,
                        color: accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpace.xxxl),
                  // Elegant slim gold indicator
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
