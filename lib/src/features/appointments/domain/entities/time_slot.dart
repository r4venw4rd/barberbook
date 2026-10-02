import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot.freezed.dart';

@freezed
abstract class TimeSlot with _$TimeSlot {
  const factory({
    required int hour,
    required int minute,
    required bool booked,
    @Default(false) bool passed,
  }) = _TimeSlot;
  const new _();

  bool get unavailable => booked || passed;

  String get label {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
