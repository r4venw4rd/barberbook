import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_dryer_app/src/core/database/local_storage_service.dart';
import 'package:hair_dryer_app/src/features/auth/domain/entities/user.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/repositories/auth_repository.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/auth_local_service.dart';

final authLocalServiceProvider = Provider<AuthLocalService>((ref) {
  final storage = ref.watch(localStorageProvider);
  return AuthLocalService(storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.watch(authLocalServiceProvider);
  return AuthRepository(service);
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final result = await repo.getCurrentUser();
    final user = result.fold(
      (failure) => null,
      (user) => user,
    );
    return user;
  }

  Future<bool> login({
    required String email,
    required String name,
    String? phone,
  }) async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.login(email: email, name: name, phone: phone);
    final isSuccess = result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
    return isSuccess;
  }

  Future<bool> loginAsGuest() async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.loginAsGuest();
    final isSuccess = result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (guest) {
        state = AsyncValue.data(guest);
        return true;
      },
    );
    return isSuccess;
  }

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

    final repo = ref.read(authRepositoryProvider);
    final result = await repo.updateProfile(updated);
    final isSuccess = result.fold(
      (failure) => false,
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
    return isSuccess;
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);
