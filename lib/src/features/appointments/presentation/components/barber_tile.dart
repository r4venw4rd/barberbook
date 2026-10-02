import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_avatar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/gradient_tick.dart';
import 'package:hair_dryer_app/src/core/presentation/components/rating_badge.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';

class BarberTile extends StatelessWidget {
  const new({
    required this.barber,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Barber barber;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final activeColor = context.accentStrong;
    final specialty = barber.localizedSpecialty(context);

    return Semantics(
      button: true,
      selected: selected,
      label:
          '${barber.name}, $specialty, '
          'rated ${barber.rating} from ${barber.reviewCount} reviews',
      child: SoftCard(
        onTap: onTap,
        borderColor: selected ? activeColor : context.borderSurface,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAvatar(
              avatarUrl: barber.avatarUrl,
              initials: barber.initials,
              color: Color(barber.accentColorValue),
              size: 54,
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
                          barber.name,
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
                  const SizedBox(height: 2),
                  Text(
                    specialty,
                    style: textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpace.sm + 2),
                  Wrap(
                    spacing: AppSpace.sm + 2,
                    runSpacing: AppSpace.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      RatingBadge(
                        rating: barber.rating,
                        count: barber.reviewCount,
                      ),
                      Text(
                        '·',
                        style: textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        l10n.yearsExp(barber.yearsExperience),
                        style: textTheme.labelMedium,
                      ),
                      Text(
                        '·',
                        style: textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        barber.isAvailableToday
                            ? l10n.freeToday
                            : l10n.fromTomorrow,
                        style: textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
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
