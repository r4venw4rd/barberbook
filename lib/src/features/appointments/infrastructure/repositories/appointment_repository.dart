import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:hair_dryer_app/src/core/database/local_storage_service.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/time_slot.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/failures/appointment_failure.dart';
import 'package:hair_dryer_app/src/features/appointments/infrastructure/dtos/appointment_dto.dart';
import 'package:hair_dryer_app/src/features/appointments/infrastructure/dtos/barber_dto.dart';
import 'package:hair_dryer_app/src/features/appointments/infrastructure/dtos/shop_service_dto.dart';
import 'package:hair_dryer_app/src/features/appointments/infrastructure/repositories/appointment_seed_data.dart';
import 'package:hair_dryer_app/src/features/appointments/infrastructure/services/appointment_mock_service.dart';

class AppointmentRepository {
  new({AppointmentMockService? service, this.storage})
    : _service = service ?? AppointmentMockService();

  final AppointmentMockService _service;
  final LocalStorageService? storage;

  static const String _appointmentsKey = 'bb_appointments_v1';

  Future<Either<AppointmentFailure, List<ShopService>>> getServices() async {
    try {
      final rawList = await _service.fetchServices();
      final services = rawList
          .map((json) => ShopServiceDto.fromJson(json).toDomain())
          .toList();
      return right(services);
    } on Exception catch (e) {
      return left(AppointmentFailure.serverError(e.toString()));
    }
  }

  Future<Either<AppointmentFailure, List<Barber>>> getBarbers() async {
    try {
      final rawList = await _service.fetchBarbers();
      final barbers = rawList
          .map((json) => BarberDto.fromJson(json).toDomain())
          .toList();
      return right(barbers);
    } on Exception catch (e) {
      return left(AppointmentFailure.serverError(e.toString()));
    }
  }

  List<Appointment> getInitialAppointments() {
    if (storage != null) {
      final stored = storage!.getJsonList(_appointmentsKey);
      if (stored != null) {
        return stored
            .map((json) => AppointmentDto.fromJson(json).toDomain())
            .toList();
      }
    }

    final defaultList = buildAppointmentSeedData(DateTime.now());

    if (storage != null) {
      unawaited(persistAppointments(defaultList));
    }

    return defaultList;
  }

  Future<Either<AppointmentFailure, List<Appointment>>>
  getAppointments() async {
    try {
      return right(getInitialAppointments());
    } on Exception catch (e) {
      return left(AppointmentFailure.serverError(e.toString()));
    }
  }

  Future<Either<AppointmentFailure, Unit>> persistAppointments(
    List<Appointment> list,
  ) async {
    try {
      if (storage != null) {
        final jsonList = list
            .map((a) => AppointmentDto.fromDomain(a).toJson())
            .toList();
        await storage!.setJsonList(_appointmentsKey, jsonList);
      }
      return right(unit);
    } on Exception catch (e) {
      return left(AppointmentFailure.serverError(e.toString()));
    }
  }

  Either<AppointmentFailure, List<TimeSlot>> getSlotsForDate(DateTime date) {
    try {
      const allHours = [
        (9, 0),
        (9, 30),
        (10, 0),
        (10, 30),
        (11, 0),
        (11, 30),
        (12, 0),
        (13, 0),
        (13, 30),
        (14, 0),
        (14, 30),
        (15, 0),
        (15, 30),
        (16, 0),
        (16, 30),
        (17, 0),
        (17, 30),
        (18, 0),
      ];
      final now = DateTime.now();
      final isToday =
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
      final leadTime = now.add(const Duration(minutes: 30));

      final slots = [
        for (var i = 0; i < allHours.length; i++)
          TimeSlot(
            hour: allHours[i].$1,
            minute: allHours[i].$2,
            booked: _isSlotBooked(date, i),
            passed:
                isToday &&
                DateTime(
                  date.year,
                  date.month,
                  date.day,
                  allHours[i].$1,
                  allHours[i].$2,
                ).isBefore(leadTime),
          ),
      ];
      return right(slots);
    } on Exception catch (e) {
      return left(AppointmentFailure.serverError(e.toString()));
    }
  }

  static bool _isSlotBooked(DateTime date, int slotIndex) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    return ((seed * 31 + slotIndex * 17) % 7) < 2;
  }
}
