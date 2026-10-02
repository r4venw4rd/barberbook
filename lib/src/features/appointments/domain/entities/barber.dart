import 'package:freezed_annotation/freezed_annotation.dart';

part 'barber.freezed.dart';

@freezed
abstract class Barber with _$Barber {
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
  }) = _Barber;
  const new _();

  String get firstName => name.split(' ').first;
}
