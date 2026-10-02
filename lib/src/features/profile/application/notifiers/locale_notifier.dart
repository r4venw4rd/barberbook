import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the application locale override.
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null; // null represents system default locale

  /// Sets the active locale.
  void setLocale(Locale? locale) {
    if (state != locale) {
      state = locale;
    }
  }
}

/// Provider for app locale.
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);
