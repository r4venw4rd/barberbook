import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/l10n/l10n_extension.dart';
import 'package:hair_dryer_app/src/core/presentation/components/content_constraint.dart';
import 'package:hair_dryer_app/src/core/presentation/components/section_header.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/account_section_card.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/appearance_section_card.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/language_section_card.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/profile_header_card.dart';
import 'package:hair_dryer_app/src/features/profile/presentation/components/support_section_card.dart';

class ProfilePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          child: ListView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom + 80,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.lg,
                  AppSpace.md,
                  AppSpace.lg,
                  AppSpace.lg,
                ),
                child: Text(l10n.profile, style: textTheme.headlineSmall),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpace.lg),
                child: ProfileHeaderCard(),
              ),
              SectionHeader(title: l10n.account),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpace.lg),
                child: AccountSectionCard(),
              ),
              SectionHeader(title: l10n.appearance),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpace.lg),
                child: AppearanceSectionCard(),
              ),
              SectionHeader(title: l10n.language),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpace.lg),
                child: LanguageSectionCard(),
              ),
              SectionHeader(title: l10n.support),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpace.lg),
                child: SupportSectionCard(),
              ),
              const SizedBox(height: AppSpace.xl),
              Center(
                child: Text(l10n.versionLabel, style: textTheme.labelSmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
