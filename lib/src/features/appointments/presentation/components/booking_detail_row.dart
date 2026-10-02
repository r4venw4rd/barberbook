import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

class BookingDetailRow extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
    this.emphasis = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fg = emphasis
        ? textTheme.titleMedium?.color
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.sm + 2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: AppSpace.md),
          Text(label, style: textTheme.bodySmall),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: emphasis
                  ? textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
                  : textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
