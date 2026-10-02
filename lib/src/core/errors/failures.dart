import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory server({String? message}) = _ServerFailure;
  const factory notFound({String? message}) = _NotFoundFailure;
  const factory validation({required String message}) = _ValidationFailure;
  const factory unexpected({String? message}) = _UnexpectedFailure;
}
