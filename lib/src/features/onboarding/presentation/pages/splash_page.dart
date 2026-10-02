import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_background_pattern.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/onboarding/application/notifiers/onboarding_notifier.dart';
import 'package:hair_dryer_app/src/features/onboarding/presentation/components/splash_brand_content.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Animated launch screen that routes users to onboarding or their next page.
class SplashPage extends HookConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );
    final fade = useMemoized(
      () => CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      [controller],
    );
    final scale = useMemoized(
      () => Tween<double>(begin: 0.88, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      ),
      [controller],
    );

    useEffect(() {
      controller.forward();
      final timer = Timer(const Duration(milliseconds: 1700), () {
        unawaited(_navigateNext(context, ref));
      });
      return timer.cancel;
    }, [controller]);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AppBackgroundPattern(
        child: Center(
          child: FadeTransition(
            opacity: fade,
            child: ScaleTransition(
              scale: scale,
              child: SplashBrandContent(
                isDark: context.isDarkTheme,
                accent: context.accentStrong,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateNext(BuildContext context, WidgetRef ref) async {
    if (!context.mounted) return;
    if (!ref.read(onboardingCompletedProvider)) {
      context.go('/welcome');
      return;
    }

    final user = await ref
        .read(authNotifierProvider.future)
        .catchError((Object _) => null);
    if (!context.mounted) return;
    context.go(user == null ? '/auth' : '/home');
  }
}
