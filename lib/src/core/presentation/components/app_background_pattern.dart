import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';

/// A CustomPainter that draws a subtle diagonal crosshatch / dot-grid pattern
/// suitable for premium dark/light backgrounds.
///
/// Light mode: near-invisible warm-grey diagonal lines
/// Dark mode: faint gold-tinted dots/lines for a luxury texture
class _BackgroundPatternPainter extends CustomPainter {
  const new({required this.isDark, required this.color});

  final bool isDark;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const spacing = 28.0; // grid cell size

    // --- Diagonal lines (45°) ---
    final total = size.width + size.height;
    final steps = (total / spacing).ceil() + 2;
    for (var i = -2; i < steps; i++) {
      final offset = i * spacing;
      // top-left to bottom-right diagonal
      canvas.drawLine(
        Offset(offset, 0),
        Offset(offset + size.height, size.height),
        paint,
      );
    }

    // --- Dot grid at intersections ---
    final dotPaint = Paint()
      ..color = color.withValues(alpha: color.a * 1.6 > 1 ? 1 : color.a * 1.6)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        // Only draw dots where diagonal lines intersect verticals
        canvas.drawCircle(Offset(x, y), 0.9, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_BackgroundPatternPainter old) =>
      old.isDark != isDark || old.color != color;
}

/// A widget that paints a premium diagonal-line + dot-grid texture
/// behind its [child]. The pattern uses 45° lines and intersection dots
/// at very low opacity so it adds depth without distraction.
class AppBackgroundPattern extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light: warm grey lines barely visible
    // Dark: faint champagne gold tint
    final patternColor = isDark
        ? AppColors.darkPrimary.withValues(alpha: 0.04)
        : AppColors.foreground.withValues(alpha: 0.032);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Pattern layer
        RepaintBoundary(
          child: CustomPaint(
            painter: _BackgroundPatternPainter(
              isDark: isDark,
              color: patternColor,
            ),
            child: const SizedBox.expand(),
          ),
        ),
        // Content on top
        child,
      ],
    );
  }
}
