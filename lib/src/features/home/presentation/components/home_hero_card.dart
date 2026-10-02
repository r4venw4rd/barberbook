import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/primary_button.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/hero_brand_pill.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/hero_scissors_art.dart';

/// Prominent top card presenting primary brand identity and appointment CTA.
class HomeHeroCard extends ConsumerWidget {
  const new({required this.onBook, super.key});

  final VoidCallback onBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final isDark = context.isDarkTheme;
    final accent = context.accentStrong;
    final slots = ref.watch(dateSlotsProvider(DateTime.now()));
    final openToday = [for (final s in slots) if (!s.unavailable) s];
    final subtitle = openToday.isEmpty
        ? l10n.heroSubtitleClosed
        : l10n.heroSubtitleSlot(openToday.first.label, 'Marcus');

    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
      decoration: BoxDecoration(
        gradient: context.heroGradient,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: accent.withValues(alpha: isDark ? 0.3 : 0.2)),
        boxShadow: reduceMotion ? null : [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.36)
                : accent.withValues(alpha: 0.08),
            blurRadius: isDark ? 28 : 20,
            offset: Offset(0, isDark ? 12 : 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          HeroScissorsArt(isDark: isDark, accent: accent),
          Padding(
            padding: const EdgeInsets.all(AppSpace.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeroBrandPill(),
                const SizedBox(height: AppSpace.md),
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Text(
                    l10n.heroTitle,
                    style: textTheme.headlineSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkForeground
                          : AppColors.foreground,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.sm + 2),
                Padding(
                  padding: const EdgeInsets.only(right: 64),
                  child: Text(
                    subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkMutedForeground
                          : AppColors.mutedForeground,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.xl),
                Row(
                  children: [
                    PrimaryButton(
                      onPressed: onBook,
                      child: Text(l10n.bookAppointment),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
