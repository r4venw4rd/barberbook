import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Modal bottom sheet for quick account sign in and switching.
class AuthModal extends HookConsumerWidget {
  const new({super.key});

  /// Opens the auth modal bottom sheet.
  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.cardSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (context) => const AuthModal(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final nameController = useTextEditingController(text: 'Alex Johnson');
    final emailController = useTextEditingController(
      text: 'alex.johnson@example.com',
    );
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.xl,
        AppSpace.lg,
        AppSpace.xl,
        MediaQuery.of(context).viewInsets.bottom + AppSpace.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.borderSurface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          Text(
            l10n.accountAndSignIn,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            l10n.signInSyncDesc,
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpace.lg),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: l10n.fullName),
          ),
          const SizedBox(height: AppSpace.md),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.emailAddress),
          ),
          const SizedBox(height: AppSpace.lg),
          FilledButton(
            onPressed: () async {
              final ok = await ref.read(authNotifierProvider.notifier).login(
                email: emailController.text,
                name: nameController.text,
              );
              if (ok && context.mounted) Navigator.of(context).pop();
            },
            child: Text(l10n.signIn),
          ),
          const SizedBox(height: AppSpace.sm),
          OutlinedButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).loginAsGuest();
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text(l10n.continueAsGuest),
          ),
        ],
      ),
    );
  }
}
