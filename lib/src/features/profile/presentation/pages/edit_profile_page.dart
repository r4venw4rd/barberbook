import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/bottom_action_bar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/content_constraint.dart';
import 'package:hair_dryer_app/src/core/presentation/components/frosted_app_bar.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/avatar_edit_card.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/profile_form_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Dedicated full screen for editing user profile details.
class EditProfilePage extends HookConsumerWidget {
  /// Creates the edit profile page.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(authNotifierProvider).value;
    final nameController = useTextEditingController(text: user?.name ?? '');
    final emailController = useTextEditingController(text: user?.email ?? '');
    final phoneController = useTextEditingController(text: user?.phone ?? '');
    final isSaving = useState(false);

    Future<void> save() async {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final phone = phoneController.text.trim();

      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.nameRequired)),
        );
        return;
      }
      if (!email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.emailInvalid)),
        );
        return;
      }

      isSaving.value = true;
      final ok = await ref.read(authNotifierProvider.notifier).updateProfile(
            name: name,
            email: email,
            phone: phone,
          );
      isSaving.value = false;

      if (!context.mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdated)),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdateFailed)),
        );
      }
    }

    return Scaffold(
      appBar: FrostedAppBar(
        title: Text(l10n.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.backButton,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          child: ListView(
            padding: const EdgeInsets.all(AppSpace.lg),
            children: [
              AvatarEditCard(user: user),
              const SizedBox(height: AppSpace.lg),
              ProfileFormCard(
                nameController: nameController,
                emailController: emailController,
                phoneController: phoneController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: SizedBox(
          width: double.infinity,
          height: kTouchTarget + 4,
          child: FilledButton(
            onPressed: isSaving.value ? null : save,
            child: isSaving.value
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
                  )
                : Text(l10n.saveChanges),
          ),
        ),
      ),
    );
  }
}
