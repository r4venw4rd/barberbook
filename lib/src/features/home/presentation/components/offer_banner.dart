import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.darkCardElevated,
                    AppColors.darkCard,
                  ]
                : [
                    const Color(0xFFFFF9EF),
                    const Color(0xFFFFFBF4),
                  ],
          ),
          border: Border.all(
            color: accent.withValues(alpha: isDark ? 0.25 : 0.22),
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Row(
          children: [
            // Offer icon
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withValues(alpha: 0.20),
                    accent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppRadius.md + 2),
                border: Border.all(
                  color: accent.withValues(alpha: 0.28),
                ),
              ),
              child: Icon(
                Icons.local_offer_outlined,
                color: accent,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.offerTitle, style: textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    l10n.offerSubtitle,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            // Promo code pill
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
                    accent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: accent.withValues(alpha: 0.40),
                ),
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
