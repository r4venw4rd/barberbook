import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/primary_button.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/appointments/application/notifiers/appointments_notifier.dart';
import 'package:hair_dryer_app/src/features/home/presentation/components/snipping_scissors.dart';

class HomeHeroCard extends ConsumerWidget {
  const new({required this.onBook, super.key});

  final VoidCallback onBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final slots = ref.watch(dateSlotsProvider(DateTime.now()));
    final openToday = [
      for (final s in slots)
        if (!s.unavailable) s,
    ];
    final subtitle = openToday.isEmpty
        ? l10n.heroSubtitleClosed
        : l10n.heroSubtitleSlot(openToday.first.label, 'Marcus');

    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: reduceMotion
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.36),
                  blurRadius: 28,
                  spreadRadius: 0,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 8,
                  spreadRadius: -2,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Stack(
        children: [
          // Gold shimmer overlay — top-left quadrant
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: AppColors.goldShimmerGradient,
              ),
            ),
          ),
          // Decorative scissors
          Positioned(
            right: -20,
            top: -12,
            child: Transform.rotate(
              angle: -0.42,
              child: SnippingScissors(
                size: 200,
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: 0.10,
                ),
                pivotColor: Theme.of(context).colorScheme.primary.withValues(
                  alpha: 0.55,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpace.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pill label — premium brand label
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.md,
                    vertical: AppSpace.xs + 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkPrimary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: AppColors.darkPrimary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    '✦  BarberBook',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.darkPrimary,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.md),
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Text(
                    l10n.heroTitle,
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
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
                      color: Colors.white.withValues(alpha: 0.76),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.xl),
                // CTA row
                Row(
                  children: [
                    PrimaryButton(
                      onPressed: onBook,
                      gradient: AppColors.darkPrimaryGradient,
                      foregroundColor: AppColors.darkOnPrimary,
                      child: Text(
                        l10n.bookAppointment,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
