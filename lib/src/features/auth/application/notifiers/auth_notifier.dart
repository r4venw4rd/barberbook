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

/// Last authentication failure reported to the UI.
class AuthFailureNotifier extends Notifier<Object?> {
  @override
  Object? build() => null;

  /// The failure forms should render, if any.
  Object? get failure => state;

  /// Publishes the failure that forms should render.
  set failure(Object? value) => state = value;

  /// Drops any previously reported failure.
  void clear() => state = null;
}

final authFailureProvider = NotifierProvider<AuthFailureNotifier, Object?>(
  AuthFailureNotifier.new,
);

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
  }) {
    return _attempt(
      ref
          .read(authRepositoryProvider)
          .register(name: name, email: email, password: password, phone: phone),
    );
  }

  /// Verifies credentials and stores the session.
  Future<bool> login({required String email, required String password}) {
    return _attempt(
      ref.read(authRepositoryProvider).login(email: email, password: password),
    );
  }

  /// Signs in with the throwaway guest profile.
  Future<bool> loginAsGuest() {
    return _attempt(ref.read(authRepositoryProvider).loginAsGuest());
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
    return result.fold<bool>((failure) => false, (user) {
      state = AsyncValue.data(user);
      return true;
    });
  }

  /// Ends the session.
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    ref.read(authFailureProvider.notifier).clear();
    state = const AsyncValue.data(null);
  }

  /// Runs [operation] and either publishes the user or reports the failure.
  Future<bool> _attempt(Future<Either<AuthFailure, User>> operation) async {
    ref.read(authFailureProvider.notifier).clear();
    final result = await operation;
    return result.fold<bool>(
      (failure) {
        ref.read(authFailureProvider.notifier).failure = failure;
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);
