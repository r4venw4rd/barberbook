import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/features/auth/domain/failures/auth_failure.dart';

/// Single line error message styled for forms.
class AuthErrorText extends StatelessWidget {
  const new({required this.message, super.key});

  /// The message to display.
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      message,
      key: const Key('authErrorText'),
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.error,
      ),
    );
  }
}

/// Localized message for an auth [failure]; empty when there is none.
String authFailureMessage(BuildContext context, Object? failure) {
  if (failure is! AuthFailure) return '';
  final l10n = context.l10n;
  return failure.map(
    invalidCredentials: (_) => l10n.incorrectEmailOrPassword,
    userNotFound: (_) => l10n.authFailed,
    userAlreadyExists: (_) => l10n.emailAlreadyRegistered,
    invalidEmail: (_) => l10n.emailInvalid,
    weakPassword: (_) => l10n.passwordTooWeak,
    cancelled: (_) => l10n.authFailed,
    storageError: (_) => l10n.authFailed,
    unexpected: (_) => l10n.authFailed,
  );
}
