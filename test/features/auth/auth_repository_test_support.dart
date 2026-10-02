import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hair_dryer_app/src/core/database/app_database.dart';
import 'package:hair_dryer_app/src/features/auth/domain/entities/user.dart';
import 'package:hair_dryer_app/src/features/auth/domain/failures/auth_failure.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/repositories/auth_repository.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/auth_local_service.dart';
import 'package:hair_dryer_app/src/features/auth/infrastructure/services/password_hasher.dart';
import 'package:hive_ce/hive_ce.dart';

class AuthRepositoryHarness {
  late Directory tempDir;
  late AppDatabase database;
  late AuthRepository repository;

  Future<void> setUp() async {
    tempDir = await Directory.systemTemp.createTemp('bb_auth_repo_');
    database = await AppDatabase.openAt(tempDir.path);
    repository = AuthRepository(
      AuthLocalService(database),
      const PasswordHasher(iterations: 1),
    );
  }

  Future<void> tearDown() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  }

  Future<User> registerAna() async => authValue(
    await repository.register(
      name: '  Ana Diaz  ',
      email: 'Ana@Example.com',
      password: 'Sunset!Barber9',
    ),
  );
}

T authValue<T>(Either<AuthFailure, T> result) => result.fold(
  (failure) => fail('expected a value, got $failure'),
  (value) => value,
);

AuthFailure authFailure<T>(Either<AuthFailure, T> result) => result.fold(
  (failure) => failure,
  (_) => fail('expected a failure, got a value'),
);
