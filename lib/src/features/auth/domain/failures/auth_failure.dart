import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
abstract class AuthFailure with _$AuthFailure {
  const factory invalidCredentials() = _InvalidCredentials;
  const factory userNotFound() = _UserNotFound;
  const factory cancelled() = _Cancelled;
  const factory storageError(String message) = _StorageError;
  const factory unexpected(String message) = _Unexpected;
}
