import 'package:flutter/material.dart';

import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Section title with an optional trailing action, used to break a page into
/// labelled groups. Features a gold accent bar on the left of the title.
class SectionHeader extends StatelessWidget {
  /// Creates a section header.
  const new({required this.title, super.key, this.actionLabel, this.onAction});

  /// Section title text.
  final String title;

  /// Label of the trailing action button; hides the button when `null`.
  final String? actionLabel;

  /// Called when the trailing action is tapped.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = context.accentStrong;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpace.lg,
        right: AppSpace.sm,
        top: AppSpace.xl,
        bottom: AppSpace.md,
      ),
      child: Row(
        children: [
          // Gold accent bar
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [accent, accent.withValues(alpha: 0.5)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          Expanded(
            child: Text(
              title,
              style: textTheme.titleLarge?.copyWith(letterSpacing: -0.3),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: accent,
                textStyle: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
