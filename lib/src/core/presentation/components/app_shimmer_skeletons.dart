import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/presentation/components/shimmer_effect.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Horizontal service scroller placeholder.
class ServiceScrollerSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SizedBox(
        height: 158,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpace.md),
          itemBuilder: (context, _) => const SizedBox(
            width: 160,
            child: SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 46, height: 46, radius: AppRadius.md + 2),
                  Spacer(),
                  ShimmerBox(width: 100, height: 16),
                  SizedBox(height: 6),
                  ShimmerBox(width: 70, height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal barber scroller placeholder.
class BarberScrollerSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SizedBox(
        height: 186,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpace.md),
          itemBuilder: (context, _) => const SizedBox(
            width: 176,
            child: SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ShimmerBox(
                      width: 58,
                      height: 58,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: AppSpace.sm + 4),
                  ShimmerBox(width: 90, height: 14),
                  SizedBox(height: 6),
                  ShimmerBox(width: 130, height: 11),
                  Spacer(),
                  Row(
                    children: [
                      ShimmerBox(width: 44, height: 18, radius: AppRadius.sm),
                      Spacer(),
                      ShimmerBox(width: 50, height: 18, radius: AppRadius.pill),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Vertical service tile list skeleton for service booking page.
class BookingServiceSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.sm,
        ),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpace.md),
        itemBuilder: (context, _) => const SoftCard(
          radius: AppRadius.lg,
          child: Row(
            children: [
              ShimmerBox(width: 44, height: 44),
              SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 120, height: 16),
                    SizedBox(height: 6),
                    ShimmerBox(width: 180, height: 12),
                  ],
                ),
              ),
              SizedBox(width: AppSpace.md),
              ShimmerBox(width: 45, height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vertical barber tile list skeleton for barber booking page.
class BookingBarberSkeleton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.sm,
        ),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpace.md),
        itemBuilder: (context, _) => const SoftCard(
          radius: AppRadius.lg,
          child: Row(
            children: [
              ShimmerBox(width: 52, height: 52, shape: BoxShape.circle),
              SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 110, height: 16),
                    SizedBox(height: 6),
                    ShimmerBox(width: 150, height: 12),
                  ],
                ),
              ),
              SizedBox(width: AppSpace.md),
              ShimmerBox(width: 48, height: 22, radius: AppRadius.sm),
            ],
          ),
        ),
      ),
    );
  }
}
