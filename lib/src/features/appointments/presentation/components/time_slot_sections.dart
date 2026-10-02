import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/time_slot.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/notice_line.dart';
import 'package:hair_dryer_app/src/features/appointments/presentation/components/slot_section.dart';

/// Displays availability notice and time slots grouped by day period.
class TimeSlotSections extends StatelessWidget {
  const new({
    required this.slots,
    required this.selectedDate,
    required this.selectedHour,
    required this.selectedMinute,
    required this.morningLabel,
    required this.afternoonLabel,
    required this.eveningLabel,
    required this.emptyTodayLabel,
    required this.fullyBookedLabel,
    required this.onSelect,
    super.key,
  });

  final List<TimeSlot> slots;
  final DateTime selectedDate;
  final int? selectedHour;
  final int? selectedMinute;
  final String morningLabel;
  final String afternoonLabel;
  final String eveningLabel;
  final String emptyTodayLabel;
  final String fullyBookedLabel;
  final void Function(int hour, int minute) onSelect;

  @override
  Widget build(BuildContext context) {
    final morning = slots.where((slot) => slot.hour < 12).toList();
    final afternoon = slots
        .where((slot) => slot.hour >= 12 && slot.hour < 17)
        .toList();
    final evening = slots.where((slot) => slot.hour >= 17).toList();
    final isToday = selectedDate.day == DateTime.now().day;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.lg,
        AppSpace.sm,
        AppSpace.lg,
        AppSpace.xxl,
      ),
      children: [
        if (slots.every((slot) => slot.unavailable))
          NoticeLine(text: isToday ? emptyTodayLabel : fullyBookedLabel),
        SlotSection(
          title: morningLabel,
          icon: Icons.wb_twilight,
          slots: morning,
          selectedHour: selectedHour,
          selectedMinute: selectedMinute,
          onSelect: onSelect,
        ),
        SlotSection(
          title: afternoonLabel,
          icon: Icons.wb_sunny_outlined,
          slots: afternoon,
          selectedHour: selectedHour,
          selectedMinute: selectedMinute,
          onSelect: onSelect,
        ),
        SlotSection(
          title: eveningLabel,
          icon: Icons.nights_stay_outlined,
          slots: evening,
          selectedHour: selectedHour,
          selectedMinute: selectedMinute,
          onSelect: onSelect,
        ),
      ],
    );
  }
}
