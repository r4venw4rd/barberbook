import 'package:flutter/material.dart';

import 'package:hair_dryer_app/src/core/theme/app_colors.dart';

/// Compact rating read-out with a star glyph.
class RatingBadge extends StatelessWidget {
  /// Creates a rating badge.
  const new({required this.rating, super.key, this.count});

  /// Rating value, rendered with one decimal place.
  final double rating;

  /// Optional number of reviews behind [rating].
  final int? count;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, size: 15, color: AppColors.ratingStar),
        const SizedBox(width: 3),
        Text(
          count == null
              ? rating.toStringAsFixed(1)
              : '${rating.toStringAsFixed(1)} ($count)',
          style: style?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
