import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hair_dryer_app/src/features/auth/domain/entities/user.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
abstract class UserDto with _$UserDto {
  const factory({
    required String id,
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
    @Default(false) bool isGuest,
  }) = _UserDto;
  const new _();

  factory fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  factory fromDomain(User user) => UserDto(
    id: user.id,
    name: user.name,
    email: user.email,
    phone: user.phone,
    avatarUrl: user.avatarUrl,
    isGuest: user.isGuest,
  );

  User toDomain() => User(
    id: id,
    name: name,
    email: email,
    phone: phone,
    avatarUrl: avatarUrl,
    isGuest: isGuest,
  );
}
