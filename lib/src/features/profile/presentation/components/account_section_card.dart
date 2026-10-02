import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/auth/presentation/components/auth_modal.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/profile_menu_tile.dart';

class AccountSectionCard extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(authNotifierProvider).value;

    return SoftCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ProfileMenuTile(
            icon: Icons.person_outline,
            label: l10n.personalDetails,
            onTap: () {
              if (user != null && !user.isGuest) {
                unawaited(context.push('/profile/edit'));
              } else {
                unawaited(AuthModal.show(context));
              }
            },
          ),
          const Divider(height: 1, indent: 56),
          ProfileMenuTile(
            icon: Icons.switch_account_outlined,
            label: user?.isGuest == true ? l10n.signIn : l10n.switchAccount,
            onTap: () => unawaited(AuthModal.show(context)),
          ),
          const Divider(height: 1, indent: 56),
          ProfileMenuTile(
            icon: Icons.notifications_outlined,
            label: l10n.pushNotifications,
            trailing: Switch.adaptive(
              value: true,
              onChanged: (value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value ? l10n.remindersEnabled : l10n.remindersDisabled,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
