import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_shimmer.dart';
import 'package:hair_dryer_app/src/core/presentation/components/bouncing_button.dart';
import 'package:hair_dryer_app/src/core/presentation/components/frosted_app_bar.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

void main() {
  group('Premium UI Components Tests', () {
    testWidgets('AppShimmer renders skeleton placeholders and animates', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: ServiceScrollerSkeleton(),
          ),
        ),
      );

      expect(find.byType(AppShimmer), findsOneWidget);
      expect(find.byType(ShimmerBox), findsWidgets);

      // Advance animation frame
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ShimmerBox), findsWidgets);
    });

    testWidgets('BouncingWrapper scales down on tap down and resets on release', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Center(
              child: BouncingWrapper(
                onTap: () => tapped = true,
                child: const Text('Bounce Me'),
              ),
            ),
          ),
        ),
      );

      final textFinder = find.text('Bounce Me');
      expect(textFinder, findsOneWidget);

      final gesture = await tester.startGesture(tester.getCenter(textFinder));
      await tester.pump(const Duration(milliseconds: 50));

      final animatedScale = tester.widget<AnimatedScale>(
        find.ancestor(of: textFinder, matching: find.byType(AnimatedScale)).first,
      );
      expect(animatedScale.scale, equals(0.96));

      await gesture.up();
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
      final resetScale = tester.widget<AnimatedScale>(
        find.ancestor(of: textFinder, matching: find.byType(AnimatedScale)).first,
      );
      expect(resetScale.scale, equals(1.0));
    });

    testWidgets('FrostedAppBar renders with BackdropFilter and title', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            appBar: FrostedAppBar(
              title: Text('Frosted Title'),
            ),
            body: Text('Content'),
          ),
        ),
      );

      expect(find.text('Frosted Title'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(find.byType(FrostedAppBar), findsOneWidget);
    });
  });
}
