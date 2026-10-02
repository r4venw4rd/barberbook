import 'package:flutter/widgets.dart';
import 'package:hair_dryer_app/src/core/l10n/generated/app_localizations.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/appointment.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/barber.dart';
import 'package:hair_dryer_app/src/features/appointments/domain/entities/shop_service.dart';

/// Extension for convenient access to [AppLocalizations].
extension L10nExtension on BuildContext {
  /// The active [AppLocalizations] instance.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Localization helpers for [ShopService].
extension LocalizedShopService on ShopService {
  /// Localized service name based on active locale.
  String localizedName(BuildContext context) {
    final l10n = context.l10n;
    return switch (id) {
      'classic-cut' => l10n.serviceClassicCutName,
      'skin-fade' => l10n.serviceSkinFadeName,
      'beard-trim' => l10n.serviceBeardTrimName,
      'hot-towel-shave' => l10n.serviceHotTowelShaveName,
      'wash-style' => l10n.serviceWashStyleName,
      'kids-cut' => l10n.serviceKidsCutName,
      'full-package' => l10n.serviceFullPackageName,
      _ => name,
    };
  }

  /// Localized service description based on active locale.
  String localizedDescription(BuildContext context) {
    final l10n = context.l10n;
    return switch (id) {
      'classic-cut' => l10n.serviceClassicCutDesc,
      'skin-fade' => l10n.serviceSkinFadeDesc,
      'beard-trim' => l10n.serviceBeardTrimDesc,
      'hot-towel-shave' => l10n.serviceHotTowelShaveDesc,
      'wash-style' => l10n.serviceWashStyleDesc,
      'kids-cut' => l10n.serviceKidsCutDesc,
      'full-package' => l10n.serviceFullPackageDesc,
      _ => description,
    };
  }

  /// Localized duration label (e.g. '30 dk' or '30 min').
  String localizedDuration(BuildContext context) {
    return context.l10n.durationMinutes(durationMinutes);
  }
}

/// Localization helpers for [Barber].
extension LocalizedBarber on Barber {
  /// Localized specialty based on active locale.
  String localizedSpecialty(BuildContext context) {
    final l10n = context.l10n;
    return switch (id) {
      'marcus' => l10n.barberMarcusSpecialty,
      'diego' => l10n.barberDiegoSpecialty,
      'liam' => l10n.barberLiamSpecialty,
      'sofia' => l10n.barberSofiaSpecialty,
      _ => specialty,
    };
  }
}

/// Localization helpers for [Appointment].
extension LocalizedAppointment on Appointment {
  /// Localized notes for seed or default appointments.
  String localizedNotes(BuildContext context) {
    if (notes == 'Same length on top as last time') {
      return context.l10n.seedAppointmentNote;
    }
    return notes;
  }
}
