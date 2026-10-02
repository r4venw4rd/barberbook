import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hair_dryer_app/src/core/presentation/components/primary_button.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

void _noop() {}

void main() {
  Widget wrap(Widget child, {Brightness brightness = Brightness.light}) {
    return MaterialApp(
      theme: brightness == Brightness.light
          ? AppTheme.light()
          : AppTheme.dark(),
      home: Scaffold(body: Center(child: child)),
    );
  }

  BoxDecoration fillOf(WidgetTester tester) {
    final container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(PrimaryButton),
        matching: find.byType(AnimatedContainer),
      ),
    );
    return container.decoration! as BoxDecoration;
  }

  testWidgets('Given the button, When rendered in light mode, '
      'Then it wears the brand gradient and gold glow', (tester) async {
    await tester.pumpWidget(
      wrap(const PrimaryButton(onPressed: _noop, child: Text('Continue'))),
    );

    final decoration = fillOf(tester);
    expect(decoration.gradient, AppColors.primaryGradient);
    expect(decoration.boxShadow!.single.color, AppColors.shadowPrimary);
    expect(decoration.borderRadius, BorderRadius.circular(AppRadius.lg));
  });

  testWidgets('Given the button, When rendered in dark mode, '
      'Then it wears the dark champagne gradient and glow', (tester) async {
    await tester.pumpWidget(
      wrap(
        const PrimaryButton(onPressed: _noop, child: Text('Continue')),
        brightness: Brightness.dark,
      ),
    );

    final decoration = fillOf(tester);
    expect(decoration.gradient, AppColors.darkPrimaryGradient);
    expect(decoration.boxShadow!.single.color, AppColors.darkShadowPrimary);
  });

  testWidgets('Given the button, When tapped, '
      'Then the callback fires once', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        PrimaryButton(onPressed: () => taps++, child: const Text('Continue')),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('Given a disabled button, When rendered, '
      'Then it is dimmed and ignores taps', (tester) async {
    const taps = 0;
    await tester.pumpWidget(
      wrap(const PrimaryButton(onPressed: null, child: Text('Continue'))),
    );

    final opacity = tester.widget<AnimatedOpacity>(
      find.descendant(
        of: find.byType(PrimaryButton),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(opacity.opacity, 0.45);

    await tester.tap(find.text('Continue'), warnIfMissed: false);
    await tester.pump();
    expect(taps, 0);
  });
}
