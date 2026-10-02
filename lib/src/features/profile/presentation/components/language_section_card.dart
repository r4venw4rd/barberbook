import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/locale_notifier.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/profile_menu_tile.dart';

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
              trailing: entry.$1 == activeLocale
                  ? Icon(
                      Icons.check_circle,
                      color: context.accentStrong,
                    )
                  : const SizedBox.shrink(),
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
