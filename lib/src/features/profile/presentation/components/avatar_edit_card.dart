import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/app_avatar.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/auth/domain/entities/user.dart';

/// Card showing large avatar with interactive photo badge.
class AvatarEditCard extends StatelessWidget {
  /// Creates the avatar edit card.
  const new({required this.user, super.key});

  /// The active user.
  final User? user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return SoftCard(
      child: Center(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AppAvatar(
                  avatarUrl: user?.avatarUrl,
                  initials: user?.initials ?? 'GU',
                  color: context.accentStrong,
                  size: 84,
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpace.xs + 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.cardSurface, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.md),
            Text(
              user?.name ?? l10n.guestUser,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              user?.isGuest == true ? l10n.guestAccount : l10n.memberSince,
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
