import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment_status.dart';
import 'package:hair_dryer_app/src/features/appointments/infrastructure/dtos/barber_dto.dart';
import 'package:hair_dryer_app/src/features/appointments/infrastructure/dtos/shop_service_dto.dart';

part 'appointment_dto.freezed.dart';
part 'appointment_dto.g.dart';

@freezed
abstract class AppointmentDto with _$AppointmentDto {
  const factory({
    required String id,
    required ShopServiceDto service,
    required BarberDto barber,
    required String startIso,
    required String notes,
    required String status,
    required double price,
  }) = _AppointmentDto;
  const new _();

  factory fromJson(Map<String, dynamic> json) => _$AppointmentDtoFromJson(json);

  factory fromDomain(Appointment appointment) => AppointmentDto(
    id: appointment.id,
    service: ShopServiceDto.fromDomain(appointment.service),
    barber: BarberDto.fromDomain(appointment.barber),
    startIso: appointment.start.toIso8601String(),
    notes: appointment.notes,
    status: appointment.status.name,
    price: appointment.price,
  );

  Appointment toDomain() => Appointment(
    id: id,
    service: service.toDomain(),
    barber: barber.toDomain(),
    start: DateTime.parse(startIso),
    notes: notes,
    status: AppointmentStatus.values.byName(status),
    price: price,
  );
}
