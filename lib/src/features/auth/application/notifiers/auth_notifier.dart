import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hair_dryer_app/src/core/database/app_database.dart';
import 'package:hair_dryer_app/src/features/auth/domain/entities/user.dart';
import 'package:hair_dryer_app/src/features/auth/domain/failures/auth_failure.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/repositories/auth_repository.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/auth_local_service.dart';

final authLocalServiceProvider = Provider<AuthLocalService>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return AuthLocalService(database);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.watch(authLocalServiceProvider);
  return AuthRepository(service);
});

/// Reactive holder of the signed-in user, backed by the local database.
class AuthNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    final result = await ref.watch(authRepositoryProvider).getCurrentUser();
    return result.fold<User?>((_) => null, (user) => user);
  }

  /// Creates an account, signs in and stores the session.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref.read(authRepositoryProvider).register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    return _publish(result);
  }

  /// Verifies credentials and stores the session.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    return _publish(result);
  }

  /// Signs in with the throwaway guest profile.
  Future<bool> loginAsGuest() async {
    state = const AsyncValue.loading();
    final result = await ref.read(authRepositoryProvider).loginAsGuest();
    return _publish(result);
  }

  /// Updates profile details of the signed-in user.
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final current = state.value;
    if (current == null) return false;

    final updated = current.copyWith(
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );

    final result = await ref
        .read(authRepositoryProvider)
        .updateProfile(updated);
    return result.fold<bool>(
      (failure) => false,
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  /// Ends the session.
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }

  bool _publish(Either<AuthFailure, User> result) {
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);
