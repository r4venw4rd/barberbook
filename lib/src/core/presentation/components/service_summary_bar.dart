import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/service_icon.dart';

/// Compact recap of the chosen service, shown on later funnel steps.
class ServiceSummaryBar extends StatelessWidget {
  const new({required this.service, super.key});

  final ShopService service;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = context.isDarkTheme;
    final accent = context.accentStrong;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: AppSpace.sm + 2,
        ),
        decoration: BoxDecoration(
          gradient: context.summaryGradient,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: accent.withValues(alpha: isDark ? 0.35 : 0.20),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.20)
                  : accent.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: context.primaryGradient,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                boxShadow: [
                  BoxShadow(
                    color: context.primaryShadow.withValues(alpha: 0.30),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                serviceIcon(service),
                size: 15,
                color: AppColors.onPrimary,
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: Text(
                service.localizedName(context),
                style: textTheme.titleSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${service.priceLabel} · ${service.localizedDuration(context)}',
              style: textTheme.labelMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
