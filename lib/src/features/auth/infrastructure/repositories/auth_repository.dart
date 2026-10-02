import 'dart:convert';
import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:hair_dryer_app/src/features/auth/domain/entities/user.dart';
import 'package:hair_dryer_app/src/features/auth/domain/failures/auth_failure.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/dtos/user_dto.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/auth_local_service.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/password_hasher.dart';

/// Repository enforcing authentication rules over the local credential store.
class AuthRepository {
  /// Creates the repository around [service] and a password [hasher].
  const new(this._service, [this._hasher = const PasswordHasher()]);

  final AuthLocalService _service;
  final PasswordHasher _hasher;

  static final Random _secureRandom = Random.secure();
  static const Duration _sessionTtl = Duration(days: 30);
  static final RegExp _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final RegExp _letterPattern = RegExp(r'[A-Za-z]');
  static final RegExp _digitPattern = RegExp(r'[0-9]');

  /// Restores the active session, clearing it when it cannot be trusted.
  Future<Either<AuthFailure, User?>> getCurrentUser() async {
    try {
      final session = await _service.fetchSession();
      if (session == null) return right(null);
      final userId = session['userId'];
      if (userId is! String || _isExpired(session['expiresAt'])) {
        await _service.clearSession();
        return right(null);
      }
      final record = await _service.fetchUser(userId);
      if (record == null) {
        await _service.clearSession();
        return right(null);
      }
      return right(UserDto.fromJson(record).toDomain());
    } on Object catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }

  /// Creates a local account and starts a session for it.
  Future<Either<AuthFailure, User>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final normalizedEmail = AuthLocalService.normalizeEmail(email);
      if (name.trim().isEmpty) {
        return left(const AuthFailure.unexpected('Name cannot be empty'));
      }
      if (!_isValidEmail(normalizedEmail)) {
        return left(const AuthFailure.invalidEmail());
      }
      if (!_isStrongPassword(password)) {
        return left(const AuthFailure.weakPassword());
      }
      if (await _service.fetchUserByEmail(normalizedEmail) != null) {
        return left(const AuthFailure.userAlreadyExists());
      }
      final now = DateTime.now().toUtc();
      final dto = UserDto(
        id: 'usr-${now.microsecondsSinceEpoch}',
        name: name.trim(),
        email: normalizedEmail,
        phone: _normalizePhone(phone),
        passwordHash: _hasher.hash(password),
        createdAt: now.toIso8601String(),
      );
      await _service.saveUser(dto.toJson());
      await _startSession(dto.id);
      return right(dto.toDomain());
    } on Object catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }

  /// Verifies credentials and starts a session for the matching account.
  Future<Either<AuthFailure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final record = await _service.fetchUserByEmail(email);
      if (record == null) return left(const AuthFailure.invalidCredentials());
      final dto = UserDto.fromJson(record);
      final storedHash = dto.passwordHash;
      if (storedHash == null || !_hasher.verify(password, storedHash)) {
        return left(const AuthFailure.invalidCredentials());
      }
      await _startSession(dto.id);
      return right(dto.toDomain());
    } on Object catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }

  /// Starts a session for the throwaway guest profile.
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
      await _startSession(guest.id);
      return right(guest);
    } on Object catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }

  /// Updates profile details while keeping stored credentials intact.
  Future<Either<AuthFailure, User>> updateProfile(User updatedUser) async {
    try {
      final name = updatedUser.name.trim();
      final normalizedEmail = AuthLocalService.normalizeEmail(
        updatedUser.email,
      );
      if (name.isEmpty) {
        return left(const AuthFailure.unexpected('Name cannot be empty'));
      }
      if (!_isValidEmail(normalizedEmail)) {
        return left(const AuthFailure.invalidEmail());
      }
      final stored = await _service.fetchUser(updatedUser.id);
      if (stored == null) return left(const AuthFailure.userNotFound());
      final existing = await _service.fetchUserByEmail(normalizedEmail);
      if (existing != null && existing['id'] != updatedUser.id) {
        return left(const AuthFailure.userAlreadyExists());
      }
      final dto = UserDto.fromJson(stored).copyWith(
        name: name,
        email: normalizedEmail,
        phone: updatedUser.phone.trim(),
        avatarUrl: updatedUser.avatarUrl,
      );
      await _service.saveUser(dto.toJson());
      return right(dto.toDomain());
    } on Object catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }

  /// Ends the active session.
  Future<Either<AuthFailure, Unit>> logout() async {
    try {
      await _service.clearSession();
      return right(unit);
    } on Object catch (e) {
      return left(AuthFailure.storageError(e.toString()));
    }
  }

  Future<void> _startSession(String userId) async {
    final now = DateTime.now().toUtc();
    await _service.saveSession({
      'token': _randomToken(),
      'userId': userId,
      'createdAt': now.toIso8601String(),
      'expiresAt': now.add(_sessionTtl).toIso8601String(),
    });
  }

  bool _isExpired(Object? rawExpiry) {
    if (rawExpiry is! String) return true;
    final expiry = DateTime.tryParse(rawExpiry);
    if (expiry == null) return true;
    return expiry.isBefore(DateTime.now().toUtc());
  }

  bool _isValidEmail(String email) => _emailPattern.hasMatch(email);

  bool _isStrongPassword(String password) =>
      password.length >= 8 &&
      _letterPattern.hasMatch(password) &&
      _digitPattern.hasMatch(password);

  String _normalizePhone(String? phone) {
    final trimmed = phone?.trim();
    if (trimmed == null || trimmed.isEmpty) return '+1 555 0100';
    return trimmed;
  }

  String _randomToken() {
    final bytes = List<int>.generate(32, (_) => _secureRandom.nextInt(256));
    return base64UrlEncode(bytes);
  }
}
