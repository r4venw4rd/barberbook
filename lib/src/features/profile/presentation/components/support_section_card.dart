import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/profile_menu_tile.dart';

class SupportSectionCard extends ConsumerWidget {
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
            icon: Icons.auto_awesome_outlined,
            label: 'Welcome Tutorial',
            onTap: () => context.push('/welcome'),
          ),
          const Divider(height: 1, indent: 56),
          ProfileMenuTile(
            icon: Icons.help_outline,
            label: l10n.helpCenter,
            onTap: () =>
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.helpCenterInfo))),
          ),
          const Divider(height: 1, indent: 56),
          ProfileMenuTile(
            icon: Icons.chat_bubble_outline,
            label: l10n.contactShop,
            onTap: () => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.contactShopInfo))),
          ),
          if (user != null && !user.isGuest) ...[
            const Divider(height: 1, indent: 56),
            ProfileMenuTile(
              icon: Icons.logout,
              label: l10n.logOut,
              danger: true,
              onTap: () async {
                await ref.read(authNotifierProvider.notifier).logout();
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l10n.loggedOut)));
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
