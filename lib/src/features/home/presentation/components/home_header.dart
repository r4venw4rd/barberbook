import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_avatar.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/core/utils/formatters.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';
import 'package:hair_dryer_app/src/features/auth/presentation/components/auth_modal.dart';

class HomeHeader extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final user = ref.watch(authNotifierProvider).value;

    final name = user?.firstName ?? l10n.customer;
    final initials = user?.initials ?? 'BB';
    final avatarUrl = user?.avatarUrl;
    final accent = context.accentStrong;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.lg,
        AppSpace.lg,
        AppSpace.lg,
        0,
      ),
      child: Row(
        children: [
          // Tappable avatar with gold ring
          GestureDetector(
            onTap: () => unawaited(AuthModal.show(context)),
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent,
                    accent.withValues(alpha: 0.5),
                  ],
                ),
              ),
              child: AppAvatar(
                avatarUrl: avatarUrl,
                initials: initials,
                color: context.accentStrong,
                size: 42,
              ),
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting(context),
                  style: textTheme.bodySmall?.copyWith(
                    letterSpacing: 0.1,
                  ),
                ),
                Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Notification button with subtle background
          Container(
            width: kTouchTarget,
            height: kTouchTarget,
            decoration: BoxDecoration(
              color: context.mutedSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: context.borderSurface),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.noNotifications)),
              ),
              icon: Badge(
                smallSize: 7,
                child: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 22,
                ),
              ),
              tooltip: l10n.notifications,
            ),
          ),
        ],
      ),
    );
  }
}
