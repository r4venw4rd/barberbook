import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/service_icon.dart';

/// Compact recap of the chosen service, shown on later funnel steps.
class ServiceSummaryBar extends StatelessWidget {
  /// Creates a service summary bar.
  const new({required this.service, super.key});

  /// Service being summarised.
  final ShopService service;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final activeColor = context.accentStrong;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: AppSpace.sm + 2,
        ),
        decoration: BoxDecoration(
          color: activeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: activeColor.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Icon(serviceIcon(service), size: 18, color: activeColor),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: Text(
                service.localizedName(context),
                style: textTheme.titleSmall?.copyWith(color: activeColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${service.priceLabel} · ${service.localizedDuration(context)}',
              style: textTheme.labelMedium?.copyWith(
                color: activeColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
