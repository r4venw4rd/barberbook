import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Booking funnel header: back button, title, "Step X of Y" + segment bars.
class FlowHeader extends StatelessWidget {
  /// Creates a booking funnel header.
  const new({
    required this.title,
    required this.step,
    required this.totalSteps,
    super.key,
    this.onBack,
  });

  /// Title of the current funnel step.
  final String title;

  /// One-based index of the current step.
  final int step;

  /// Total number of steps in the funnel.
  final int totalSteps;

  /// Overrides the default pop behaviour of the back button.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final activeColor = context.accentStrong;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.lg,
        AppSpace.sm,
        AppSpace.lg,
        AppSpace.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: kTouchTarget,
                height: kTouchTarget,
                child: IconButton(
                  onPressed: onBack ?? () => _popIfPossible(context),
                  icon: const Icon(Icons.arrow_back),
                  tooltip: l10n.backButton,
                ),
              ),
              const SizedBox(width: AppSpace.xs),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          Padding(
            padding: const EdgeInsets.only(left: AppSpace.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.stepIndicator(step, totalSteps),
                  style: textTheme.labelMedium,
                ),
                const SizedBox(height: AppSpace.sm),
                _StepSegments(
                  step: step,
                  totalSteps: totalSteps,
                  activeColor: activeColor,
                  inactiveColor: context.mutedSurface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _popIfPossible(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }
}

/// Row of per-step progress segments for [FlowHeader].
class _StepSegments extends StatelessWidget {
  const new({
    required this.step,
    required this.totalSteps,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int step;
  final int totalSteps;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= totalSteps; i++)
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              height: 5,
              margin: EdgeInsets.only(
                right: i == totalSteps ? 0 : AppSpace.xs + 2,
              ),
              decoration: BoxDecoration(
                color: i <= step ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
      ],
    );
  }
}
