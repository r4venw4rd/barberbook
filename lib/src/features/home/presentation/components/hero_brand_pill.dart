import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Small decorative pill chip with brand name in the hero card.
class HeroBrandPill extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = context.accentStrong;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.md,
        vertical: AppSpace.xs + 1,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: context.isDarkTheme ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: accent.withValues(alpha: context.isDarkTheme ? 0.35 : 0.22),
        ),
      ),
      child: Text(
        '✦  BarberBook',
        style: textTheme.labelSmall?.copyWith(
          color: accent,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
