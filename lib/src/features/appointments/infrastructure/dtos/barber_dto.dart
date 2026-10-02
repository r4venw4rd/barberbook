import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';

part 'barber_dto.freezed.dart';
part 'barber_dto.g.dart';

@freezed
abstract class BarberDto with _$BarberDto {
  const factory({
    required String id,
    required String name,
    required String specialty,
    required int yearsExperience,
    required double rating,
    required int reviewCount,
    required String initials,
    required int accentColorValue,
    @Default(true) bool isAvailableToday,
    String? avatarUrl,
  }) = _BarberDto;
  const new _();

  factory fromJson(Map<String, dynamic> json) => _$BarberDtoFromJson(json);

  factory fromDomain(Barber barber) => BarberDto(
    id: barber.id,
    name: barber.name,
    specialty: barber.specialty,
    yearsExperience: barber.yearsExperience,
    rating: barber.rating,
    reviewCount: barber.reviewCount,
    initials: barber.initials,
    accentColorValue: barber.accentColorValue,
    isAvailableToday: barber.isAvailableToday,
    avatarUrl: barber.avatarUrl,
  );

  Barber toDomain() => Barber(
    id: id,
    name: name,
    specialty: specialty,
    yearsExperience: yearsExperience,
    rating: rating,
    reviewCount: reviewCount,
    initials: initials,
    accentColorValue: accentColorValue,
    isAvailableToday: isAvailableToday,
    avatarUrl: avatarUrl,
  );
}
