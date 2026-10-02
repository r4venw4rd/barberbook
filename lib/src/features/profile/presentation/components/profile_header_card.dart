import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_avatar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/auth/presentation/components/auth_modal.dart';

class ProfileHeaderCard extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final userAsync = ref.watch(authNotifierProvider);
    final user = userAsync.value;

    final isGuest = user == null || user.isGuest;
    final name = user?.name ?? l10n.guestUser;
    final email = user?.email ?? l10n.notSignedIn;
    final phone = user?.phone ?? l10n.signInToSave;

    return SoftCard(
      child: Row(
        children: [
          AppAvatar(
            avatarUrl: user?.avatarUrl,
            initials: user?.initials ?? 'GU',
            color: context.accentStrong,
            size: 60,
          ),
          const SizedBox(width: AppSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isGuest) ...[
                      const SizedBox(width: AppSpace.xs + 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpace.xs + 2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.mutedSurface,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: context.borderSurface),
                        ),
                        child: Text(l10n.guest, style: textTheme.labelSmall),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  phone,
                  style: textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: kTouchTarget,
            height: kTouchTarget,
            child: IconButton(
              onPressed: () {
                if (user != null && !user.isGuest) {
                  unawaited(context.push('/profile/edit'));
                } else {
                  unawaited(AuthModal.show(context));
                }
              },
              icon: Icon(isGuest ? Icons.login : Icons.edit_outlined),
              tooltip: isGuest ? l10n.signIn : l10n.editProfile,
            ),
          ),
        ],
      ),
    );
  }
}
