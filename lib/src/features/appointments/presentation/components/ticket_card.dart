import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_avatar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/rating_badge.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/core/utils/formatters.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';

/// Ticket-style visual card for booking confirmation and reviews.
class TicketCard extends StatelessWidget {
  /// Creates a ticket card.
  const new({
    required this.service,
    required this.barber,
    required this.date,
    required this.totalPrice,
    super.key,
  });

  /// The booked service.
  final ShopService service;

  /// The assigned barber.
  final Barber barber;

  /// Appointment start time.
  final DateTime date;

  /// Calculated total price.
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                avatarUrl: barber.avatarUrl,
                initials: barber.initials,
                color: Color(barber.accentColorValue),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barber.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RatingBadge(
                      rating: barber.rating,
                      count: barber.reviewCount,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: context.isDarkTheme
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: context.borderSurface),
                ),
                child: Text(
                  service.localizedDuration(context),
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: AppSpace.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TicketDetail(
                label: l10n.ticketService,
                value: service.localizedName(context),
              ),
              _TicketDetail(
                label: l10n.ticketDate,
                value: dayLabel(date, context),
              ),
              _TicketDetail(
                label: l10n.ticketTime,
                value: formatTimeOfDay(TimeOfDay.fromDateTime(date)),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.ticketTotal, style: textTheme.labelSmall),
              Text(
                formatPrice2(totalPrice),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.accentStrong,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TicketDetail extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelSmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
