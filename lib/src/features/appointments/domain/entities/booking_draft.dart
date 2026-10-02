import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';

part 'booking_draft.freezed.dart';

@freezed
abstract class BookingDraft with _$BookingDraft {
  const factory({
    ShopService? service,
    Barber? barber,
    DateTime? date,
    int? hour,
    int? minute,
    @Default('') String notes,
  }) = _BookingDraft;
  const new _();

  bool get hasService => service != null;
  bool get hasBarber => barber != null;
  bool get hasDate => date != null;
  bool get hasTime => hour != null && minute != null;
  bool get isComplete => hasService && hasBarber && hasDate && hasTime;

  DateTime? get start {
    final d = date;
    final h = hour;
    final m = minute;
    if (d == null || h == null || m == null) return null;
    return DateTime(d.year, d.month, d.day, h, m);
  }
}
