import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/primary_button.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/auth/presentation/components/auth_error_text.dart';
import 'package:hair_dryer_app/src/features/auth/presentation/components/auth_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Registration form creating a local account and its session.
class SignUpForm extends HookConsumerWidget {
  const new({super.key, this.onSignedIn});

  /// Called after the account has been created and stored.
  final VoidCallback? onSignedIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmController = useTextEditingController();
    final attempted = useState(false);
    final isSubmitting = useState(false);
    final mismatch = useState(false);
    final failure = ref.watch(authFailureProvider);

    Future<void> submit() async {
      if (isSubmitting.value) return;
      attempted.value = true;
      if (passwordController.text != confirmController.text) {
        mismatch.value = true;
        return;
      }
      mismatch.value = false;
      isSubmitting.value = true;
      final ok = await ref
          .read(authNotifierProvider.notifier)
          .register(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          );
      isSubmitting.value = false;
      if (ok) onSignedIn?.call();
    }

    final message = mismatch.value
        ? l10n.passwordsDoNotMatch
        : authFailureMessage(context, failure);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthField(label: l10n.fullName, controller: nameController),
        const SizedBox(height: AppSpace.md),
        AuthField(
          label: l10n.emailAddress,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
        ),
        const SizedBox(height: AppSpace.md),
        AuthField(
          label: l10n.password,
          controller: passwordController,
          obscure: true,
          autofillHints: const [AutofillHints.newPassword],
        ),
        const SizedBox(height: AppSpace.md),
        AuthField(
          label: l10n.confirmPassword,
          controller: confirmController,
          obscure: true,
          autofillHints: const [AutofillHints.newPassword],
        ),
        if (attempted.value && message.isNotEmpty) ...[
          const SizedBox(height: AppSpace.sm),
          AuthErrorText(message: message),
        ],
        const SizedBox(height: AppSpace.lg),
        PrimaryButton(
          onPressed: isSubmitting.value ? null : submit,
          child: isSubmitting.value
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.createAccount),
        ),
      ],
    );
  }
}
