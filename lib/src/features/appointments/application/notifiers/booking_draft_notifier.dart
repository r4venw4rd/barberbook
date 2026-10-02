import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/booking_draft.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';

class BookingDraftNotifier extends Notifier<BookingDraft> {
  @override
  BookingDraft build() => const BookingDraft();

  void selectService(ShopService service) => state = state.copyWith(
    service: service,
    // Reset time selections when service changes, but preserve barber
    // to maintain continuity in user experience
    date: null,
    hour: null,
    minute: null,
  );

  void selectBarber(Barber barber) => state = state.copyWith(barber: barber);

  void selectDate(DateTime date) =>
      state = state.copyWith(date: date, hour: null, minute: null);

  void selectTime(int hour, int minute) =>
      state = state.copyWith(hour: hour, minute: minute);

  void setNotes(String notes) => state = state.copyWith(notes: notes);

  void reset() => state = const BookingDraft();
}

final bookingDraftProvider =
    NotifierProvider<BookingDraftNotifier, BookingDraft>(
      BookingDraftNotifier.new,
    );
