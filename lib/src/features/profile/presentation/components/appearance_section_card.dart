import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/gradient_tick.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/appearance_notifier.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/profile_menu_tile.dart';

class AppearanceSectionCard extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appearanceProvider);
    final l10n = context.l10n;

    final options = [
      (ThemeMode.system, Icons.brightness_auto, l10n.systemTheme),
      (ThemeMode.light, Icons.light_mode_outlined, l10n.lightTheme),
      (ThemeMode.dark, Icons.dark_mode_outlined, l10n.darkTheme),
    ];

    return SoftCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final (index, entry) in options.indexed) ...[
            if (index > 0) const Divider(height: 1, indent: 56),
            ProfileMenuTile(
              icon: entry.$2,
              label: entry.$3,
              selected: entry.$1 == mode,
              trailing: GradientTick(
                size: 22,
                selected: entry.$1 == mode,
                isRadio: true,
              ),
              onTap: () {
                ref.read(appearanceProvider.notifier).setMode(entry.$1);
              },
            ),
          ],
        ],
      ),
    );
  }
}
