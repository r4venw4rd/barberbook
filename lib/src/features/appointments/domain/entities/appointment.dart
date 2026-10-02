import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment_status.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';

part 'appointment.freezed.dart';

@freezed
abstract class Appointment with _$Appointment {
  const factory({
    required String id,
    required ShopService service,
    required Barber barber,
    required DateTime start,
    required String notes,
    required AppointmentStatus status,
    required double price,
  }) = _Appointment;
  const new _();

  bool get isUpcoming =>
      status == AppointmentStatus.confirmed ||
      status == AppointmentStatus.pending;
}
