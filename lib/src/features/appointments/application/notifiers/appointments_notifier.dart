import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hair_dryer_app/src/core/database/local_storage_service.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment_status.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/time_slot.dart';
import 'package:hair_dryer_app/src/features/appointments/infrastructure/repositories/appointment_repository.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final storage = ref.watch(localStorageProvider);
  return AppointmentRepository(storage: storage);
});

final servicesProvider = FutureProvider<List<ShopService>>((ref) {
  final repo = ref.watch(appointmentRepositoryProvider);
  return repo.getServices().then(
    (result) => result.fold(
      (failure) => throw Exception(failure.toString()),
      (services) => services,
    ),
  );
});

final barbersProvider = FutureProvider<List<Barber>>((ref) {
  final repo = ref.watch(appointmentRepositoryProvider);
  return repo.getBarbers().then(
    (result) => result.fold(
      (failure) => throw Exception(failure.toString()),
      (barbers) => barbers,
    ),
  );
});

final ProviderFamily<List<TimeSlot>, DateTime> dateSlotsProvider =
    Provider.family<List<TimeSlot>, DateTime>((ref, date) {
      final repo = ref.watch(appointmentRepositoryProvider);
      final result = repo.getSlotsForDate(date);
      return result.fold((failure) => <TimeSlot>[], (slots) => slots);
    });

class AppointmentsNotifier extends Notifier<List<Appointment>> {
  @override
  List<Appointment> build() {
    final repo = ref.watch(appointmentRepositoryProvider);
    return repo.getInitialAppointments();
  }

  void add(Appointment appointment) {
    state = [appointment, ...state];
    unawaited(
      ref.read(appointmentRepositoryProvider).persistAppointments(state),
    );
  }

  void cancel(String id) {
    state = [
      for (final a in state)
        if (a.id == id) a.copyWith(status: AppointmentStatus.cancelled) else a,
    ];
    unawaited(
      ref.read(appointmentRepositoryProvider).persistAppointments(state),
    );
  }

  void remove(String id) {
    state = [
      for (final a in state)
        if (a.id != id) a,
    ];
    unawaited(
      ref.read(appointmentRepositoryProvider).persistAppointments(state),
    );
  }
}

final appointmentsProvider =
    NotifierProvider<AppointmentsNotifier, List<Appointment>>(
      AppointmentsNotifier.new,
    );

final upcomingAppointmentsProvider = Provider<List<Appointment>>((ref) {
  final now = DateTime.now();
  final all = ref.watch(appointmentsProvider);
  final result = [
    for (final a in all)
      if (a.isUpcoming && a.start.isAfter(now)) a,
  ]..sort((a, b) => a.start.compareTo(b.start));
  return result;
});

final pastAppointmentsProvider = Provider<List<Appointment>>((ref) {
  final now = DateTime.now();
  final all = ref.watch(appointmentsProvider);
  final result = [
    for (final a in all)
      if (!a.isUpcoming || a.start.isBefore(now)) a,
  ]..sort((a, b) => b.start.compareTo(a.start));
  return result;
});
