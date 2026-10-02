import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/core/utils/formatters.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/booking_detail_row.dart';

/// Card showing appointment details breakdown during review.
class BookingDetailCard extends StatelessWidget {
  /// Creates the booking detail card.
  const new({
    required this.service,
    required this.barber,
    required this.start,
    required this.bookingFee,
    super.key,
  });

  /// The service.
  final ShopService service;

  /// The barber.
  final Barber barber;

  /// The appointment start time.
  final DateTime start;

  /// The booking fee.
  final double bookingFee;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final timeLabel =
        '${formatTimeOfDay(TimeOfDay.fromDateTime(start))} · '
        '${service.localizedDuration(context)}';
    final total = service.price + bookingFee;

    return SoftCard(
      child: Column(
        children: [
          BookingDetailRow(
            icon: Icons.content_cut,
            label: l10n.serviceLabel,
            value: service.localizedName(context),
          ),
          BookingDetailRow(
            icon: Icons.person_outline,
            label: l10n.barberLabel,
            value: barber.name,
          ),
          BookingDetailRow(
            icon: Icons.event,
            label: l10n.dateLabel,
            value: longDate(start, context),
          ),
          BookingDetailRow(
            icon: Icons.schedule,
            label: l10n.timeLabel,
            value: timeLabel,
          ),
          const Divider(height: AppSpace.xl),
          BookingDetailRow(
            icon: Icons.payments_outlined,
            label: l10n.servicePrice,
            value: formatPrice2(service.price),
          ),
          BookingDetailRow(
            icon: Icons.confirmation_num_outlined,
            label: l10n.bookingFee,
            value: formatPrice2(bookingFee),
          ),
          BookingDetailRow(
            icon: Icons.receipt_long_outlined,
            label: l10n.total,
            value: formatPrice2(total),
            emphasis: true,
          ),
        ],
      ),
    );
  }
}
