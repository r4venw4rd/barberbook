import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory({
    required String id,
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
    @Default(false) bool isGuest,
  }) = _User;
  const new _();

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  String get firstName => name.trim().split(' ').first;
}
