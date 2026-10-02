import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Promotional banner highlighting special offers with brand styling.
class OfferBanner extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final isDark = context.isDarkTheme;
    final accent = context.accentStrong;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          gradient: context.offerGradient,
          border: Border.all(
            color: accent.withValues(alpha: isDark ? 0.25 : 0.20),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.20)
                  : accent.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withValues(alpha: 0.18),
                    accent.withValues(alpha: 0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppRadius.md + 2),
                border: Border.all(color: accent.withValues(alpha: 0.28)),
              ),
              child: Icon(Icons.local_offer_outlined, color: accent, size: 22),
            ),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.offerTitle, style: textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(l10n.offerSubtitle, style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.md,
                vertical: AppSpace.sm,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withValues(alpha: 0.16),
                    accent.withValues(alpha: 0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: accent.withValues(alpha: 0.35)),
              ),
              child: Text(
                'FIRST20',
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
