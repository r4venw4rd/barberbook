import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

class NoticeLine extends StatelessWidget {
  const new({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.lg),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpace.sm),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
