import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/gradient_tick.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/service_icon.dart';

class ServiceTile extends StatelessWidget {
  const new({
    required this.service,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final ShopService service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final activeColor = context.accentStrong;
    final serviceName = service.localizedName(context);
    final serviceDesc = service.localizedDescription(context);
    final serviceDuration = service.localizedDuration(context);

    return Semantics(
      button: true,
      selected: selected,
      label:
          '$serviceName, $serviceDuration, '
          '${service.priceLabel}, $serviceDesc',
      child: SoftCard(
        onTap: onTap,
        borderColor: selected ? activeColor : context.borderSurface,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: activeColor.withValues(alpha: selected ? 0.16 : 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(serviceIcon(service), color: activeColor, size: 24),
            ),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          serviceName,
                          style: textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedScale(
                        scale: selected ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                        child: selected
                            ? const Padding(
                                padding: EdgeInsets.only(left: AppSpace.xs),
                                child: GradientTick(),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    serviceDesc,
                    style: textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpace.sm + 2),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(serviceDuration, style: textTheme.labelMedium),
                      const SizedBox(width: AppSpace.md),
                      Text(
                        service.priceLabel,
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: selected
                              ? activeColor
                              : textTheme.titleMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
