import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

class LegendDot extends StatelessWidget {
  const new({
    required this.color,
    required this.label,
    super.key,
    this.dimmed = false,
  });

  final Color color;
  final String label;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dimmed ? Colors.transparent : color,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: dimmed ? 2 : 0),
          ),
        ),
        const SizedBox(width: AppSpace.xs + 2),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
