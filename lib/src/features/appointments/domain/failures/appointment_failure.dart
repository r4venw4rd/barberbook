import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_failure.freezed.dart';

@freezed
abstract class AppointmentFailure with _$AppointmentFailure {
  const factory notFound([String? message]) = _NotFound;
  const factory slotUnavailable([String? message]) = _SlotUnavailable;
  const factory invalidData([String? message]) = _InvalidData;
  const factory serverError([String? message]) = _ServerError;
}
