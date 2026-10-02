import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Card containing notes field for barber.
class ReviewNotesCard extends StatelessWidget {
  /// Creates the review notes card.
  const new({required this.controller, required this.onChanged, super.key});

  /// The text controller for notes.
  final TextEditingController controller;

  /// Callback when text changes.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note, size: 20),
              const SizedBox(width: AppSpace.xs),
              Text(l10n.notesForBarber, style: textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          TextField(
            controller: controller,
            maxLines: 3,
            maxLength: 200,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: l10n.notesHint,
              counterText: '',
            ),
          ),
        ],
      ),
    );
  }
}
