import 'package:fpdart/fpdart.dart';
import 'package:hair_dryer_app/src/features/auth/domain/entities/user.dart';
import 'package:hair_dryer_app/src/features/auth/domain/failures/auth_failure.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/dtos/user_dto.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/auth_local_service.dart';

/// Repository enforcing authentication and local storage persistence.
class AuthRepository {
  /// Creates the auth repository.
  const new(this._service);

  final AuthLocalService _service;

  /// Gets the currently active user session, if any.
  Future<Either<AuthFailure, User?>> getCurrentUser() async {
    try {
      final raw = await _service.fetchCurrentUser();
      if (raw == null) return right(null);
      final user = UserDto.fromJson(raw).toDomain();
      return right(user);
    } on Exception catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }

  /// Logs in with email and optional custom name.
  Future<Either<AuthFailure, User>> login({
    required String email,
    required String name,
    String? phone,
  }) async {
    try {
      if (email.trim().isEmpty || !email.contains('@')) {
        return left(const AuthFailure.invalidCredentials());
      }
      final user = User(
        id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim().isNotEmpty ? name.trim() : email.split('@').first,
        email: email.trim(),
        phone: phone?.trim().isNotEmpty == true ? phone!.trim() : '+1 555 0100',
        avatarUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=300&auto=format&fit=crop&q=80',
      );
      await _service.saveUser(UserDto.fromDomain(user).toJson());
      return right(user);
    } on Exception catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }

  /// Logs in as a guest user.
  Future<Either<AuthFailure, User>> loginAsGuest() async {
    try {
      const guest = User(
        id: 'usr-guest',
        name: 'Guest Customer',
        email: 'guest@barberbook.local',
        phone: '+1 555 0000',
        isGuest: true,
      );
      await _service.saveUser(UserDto.fromDomain(guest).toJson());
      return right(guest);
    } on Exception catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }

  /// Updates profile details of the given user.
  Future<Either<AuthFailure, User>> updateProfile(User updatedUser) async {
    try {
      if (updatedUser.name.trim().isEmpty) {
        return left(
          const AuthFailure.unexpected('Name cannot be empty'),
        );
      }
      await _service.saveUser(UserDto.fromDomain(updatedUser).toJson());
      return right(updatedUser);
    } on Exception catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }

  /// Logs out the user.
  Future<Either<AuthFailure, Unit>> logout() async {
    try {
      await _service.deleteUser();
      return right(unit);
    } on Exception catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }
}
