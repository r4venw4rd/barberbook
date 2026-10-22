import 'package:barberbook/src/features/profile/application/notifiers/appearance_notifier.dart';
import 'package:barberbook/src/features/profile/application/notifiers/locale_notifier.dart';
import 'package:flutter/material.dart';

class DarkAppearanceForTest extends AppearanceNotifier {
  @override
  ThemeMode build() => ThemeMode.dark;
}

class EnglishLocaleForTest extends LocaleNotifier {
  @override
  Locale? build() => const Locale('en');
}
