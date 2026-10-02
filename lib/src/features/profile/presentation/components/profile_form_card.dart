import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/soft_card.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

/// Card containing name, email, and phone inputs for profile editing.
class ProfileFormCard extends StatelessWidget {
  /// Creates the profile form card.
  const new({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    super.key,
  });

  /// Name input controller.
  final TextEditingController nameController;

  /// Email input controller.
  final TextEditingController emailController;

  /// Phone input controller.
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.personalDetails, style: textTheme.titleSmall),
          const SizedBox(height: AppSpace.md),
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.fullName,
              prefixIcon: const Icon(Icons.person_outline, size: 20),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.emailAddress,
              prefixIcon: const Icon(Icons.mail_outline, size: 20),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l10n.phoneNumber,
              prefixIcon: const Icon(Icons.phone_outlined, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
