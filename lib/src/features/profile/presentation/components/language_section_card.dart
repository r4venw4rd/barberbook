import 'package:barberbook/src/core/l10n/l10n_extension.dart';
import 'package:barberbook/src/core/presentation/components/gradient_tick.dart';
import 'package:barberbook/src/core/presentation/components/soft_card.dart';
import 'package:barberbook/src/features/profile/application/notifiers/locale_notifier.dart';
import 'package:barberbook/src/features/profile/presentation/components/profile_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Language selection card for the profile page.
class LanguageSectionCard extends ConsumerWidget {
  /// Creates the language section card.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLocale = ref.watch(localeProvider);
    final l10n = context.l10n;

    final options = [
      (null, Icons.language_outlined, l10n.systemTheme),
      (const Locale('tr'), Icons.flag_outlined, l10n.turkishLang),
      (const Locale('en'), Icons.flag_outlined, l10n.englishLang),
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
              selected: entry.$1 == activeLocale,
              trailing: GradientTick(
                size: 22,
                selected: entry.$1 == activeLocale,
                isRadio: true,
              ),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(entry.$1);
              },
            ),
          ],
        ],
      ),
    );
  }
}
