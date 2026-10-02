import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// A brand-gradient checkmark or radio indicator.
class GradientTick extends StatelessWidget {
  const new({
    super.key,
    this.size = 20,
    this.selected = true,
    this.isRadio = false,
  });

  final double size;
  final bool selected;
  final bool isRadio;

  @override
  Widget build(BuildContext context) {
    if (!selected) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.borderSurface, width: 1.5),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: context.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: isRadio
            ? Container(
                width: size * 0.4,
                height: size * 0.4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onPrimary,
                ),
              )
            : Icon(
                Icons.check_rounded,
                size: size * 0.7,
                color: AppColors.onPrimary,
              ),
      ),
    );
  }
}
