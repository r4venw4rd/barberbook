import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Animated barber scissors with realistic opening and snipping cadence.
class SnippingScissors extends HookWidget {
  /// Creates the snipping scissors widget.
  const new({
    this.size = 180,
    this.color = const Color(0x22E5A93C),
    this.pivotColor = const Color(0x66E5A93C),
    super.key,
  });

  /// The dimension of the scissors.
  final double size;

  /// The silhouette color.
  final Color color;

  /// The center rivet color.
  final Color pivotColor;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 2400),
    );

    useEffect(() {
      if (!reduceMotion) {
        controller.repeat();
      } else {
        controller.stop();
      }
      return null;
    }, [reduceMotion]);

    final animation = useAnimation(controller);

    // Realistic barber snip cadence:
    // 0.00 -> 0.28: Open wide (0 -> 22 deg)
    // 0.28 -> 0.40: Quick crisp snip (22 -> 1 deg)
    // 0.40 -> 0.58: Open medium (1 -> 14 deg)
    // 0.58 -> 0.70: Second crisp snip (14 -> 0 deg)
    // 0.70 -> 1.00: Rest at closed position
    double openAngleRad = 0;
    if (!reduceMotion) {
      final t = animation;
      if (t < 0.28) {
        final p = Curves.easeOutCubic.transform(t / 0.28);
        openAngleRad = p * 0.38;
      } else if (t < 0.40) {
        final p = Curves.easeInQuad.transform((t - 0.28) / 0.12);
        openAngleRad = (1 - p) * 0.38 + 0.02;
      } else if (t < 0.58) {
        final p = Curves.easeOutCubic.transform((t - 0.40) / 0.18);
        openAngleRad = p * 0.24 + 0.02;
      } else if (t < 0.70) {
        final p = Curves.easeInQuad.transform((t - 0.58) / 0.12);
        openAngleRad = (1 - p) * 0.26;
      } else {
        openAngleRad = 0;
      }
    }

    return CustomPaint(
      size: Size(size, size),
      painter: _ScissorsPainter(
        color: color,
        pivotColor: pivotColor,
        openAngleRad: openAngleRad,
      ),
    );
  }
}

class _ScissorsPainter extends CustomPainter {
  const new({
    required this.color,
    required this.pivotColor,
    required this.openAngleRad,
  });

  final Color color;
  final Color pivotColor;
  final double openAngleRad;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    final pivot = Offset(size.width * 0.46, size.height * 0.50);

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw Blade 1 (Upper blade + lower handle)
    canvas
      ..save()
      ..translate(pivot.dx, pivot.dy)
      ..rotate(-openAngleRad)
      ..translate(-pivot.dx, -pivot.dy);
    _drawHalf(canvas, pivot, s, fillPaint, isUpper: true);

    // Draw Blade 2 (Lower blade + upper handle)
    canvas
      ..restore()
      ..save()
      ..translate(pivot.dx, pivot.dy)
      ..rotate(openAngleRad)
      ..translate(-pivot.dx, -pivot.dy);
    _drawHalf(canvas, pivot, s, fillPaint, isUpper: false);

    // Center pivot screw with inner hole detail
    final screwPaint = Paint()
      ..color = pivotColor
      ..style = PaintingStyle.fill;
    final screwBorderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * s;

    canvas
      ..restore()
      ..drawCircle(pivot, 4.2 * s, screwPaint)
      ..drawCircle(pivot, 4.2 * s, screwBorderPaint)
      ..drawCircle(pivot, 1.4 * s, fillPaint);
  }

  void _drawHalf(
    Canvas canvas,
    Offset pivot,
    double s,
    Paint fillPaint, {
    required bool isUpper,
  }) {
    final sign = isUpper ? -1.0 : 1.0;
    final path = Path()
      ..fillType = PathFillType.evenOdd
      // Pivot base
      ..moveTo(pivot.dx - 2 * s, pivot.dy + sign * 5 * s)
      // Blade bottom curve to sharp tip
      ..quadraticBezierTo(
        pivot.dx + 28 * s,
        pivot.dy + sign * 6 * s,
        pivot.dx + 52 * s,
        pivot.dy + sign * 1.5 * s,
      )
      // Sharp tip
      ..lineTo(pivot.dx + 54 * s, pivot.dy)
      // Blade top spine
      ..quadraticBezierTo(
        pivot.dx + 26 * s,
        pivot.dy - sign * 4 * s,
        pivot.dx,
        pivot.dy - sign * 5 * s,
      )
      // Shank extending to handle ring
      ..quadraticBezierTo(
        pivot.dx - 16 * s,
        pivot.dy - sign * 12 * s,
        pivot.dx - 28 * s,
        pivot.dy - sign * 18 * s,
      )
      // Outer handle ring oval
      ..addOval(
        Rect.fromCenter(
          center: Offset(pivot.dx - 28 * s, pivot.dy - sign * 18 * s),
          width: 22 * s,
          height: 18 * s,
        ),
      )
      // Inner handle ring hole (cutout via evenOdd)
      ..addOval(
        Rect.fromCenter(
          center: Offset(pivot.dx - 28 * s, pivot.dy - sign * 18 * s),
          width: 14 * s,
          height: 10 * s,
        ),
      );

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(_ScissorsPainter oldDelegate) =>
      oldDelegate.openAngleRad != openAngleRad ||
      oldDelegate.color != color ||
      oldDelegate.pivotColor != pivotColor;
}
