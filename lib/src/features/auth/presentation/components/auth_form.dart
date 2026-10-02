import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/auth/presentation/components/sign_in_form.dart';
import 'package:hair_dryer_app/src/features/auth/presentation/components/sign_up_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Switchable sign in / sign up forms with a guest shortcut.
class AuthForm extends HookConsumerWidget {
  const new({super.key, this.onSignedIn});

  /// Called after any successful sign in.
  final VoidCallback? onSignedIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isSignIn = useState(true);
    final isBusy = ref.watch(
      authNotifierProvider.select((state) => state.isLoading),
    );

    Future<void> continueAsGuest() async {
      final ok = await ref.read(authNotifierProvider.notifier).loginAsGuest();
      if (ok) onSignedIn?.call();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isSignIn.value)
          SignInForm(onSignedIn: onSignedIn)
        else
          SignUpForm(onSignedIn: onSignedIn),
        const SizedBox(height: AppSpace.sm),
        Center(
          child: TextButton(
            onPressed: () => isSignIn.value = !isSignIn.value,
            child: Text(
              isSignIn.value
                  ? '${l10n.noAccountYet} ${l10n.createAccount}'
                  : '${l10n.alreadyHaveAccount} ${l10n.signIn}',
            ),
          ),
        ),
        const SizedBox(height: AppSpace.xs),
        OutlinedButton(
          onPressed: isBusy ? null : continueAsGuest,
          child: Text(l10n.continueAsGuest),
        ),
      ],
    );
  }
}
