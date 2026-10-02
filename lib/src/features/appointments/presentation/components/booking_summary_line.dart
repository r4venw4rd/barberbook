import 'package:flutter/material.dart';

class BookingSummaryLine extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.trailing,
    super.key,
  });

  final IconData icon;
  final String label;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: textTheme.titleSmall)),
        Text(
          trailing,
          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
