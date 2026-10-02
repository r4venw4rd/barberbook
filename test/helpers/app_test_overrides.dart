import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/appearance_notifier.dart';
import 'package:hair_dryer_app/src/features/profile/application/notifiers/locale_notifier.dart';

class DarkAppearanceForTest extends AppearanceNotifier {
  @override
  ThemeMode build() => ThemeMode.dark;
}

class EnglishLocaleForTest extends LocaleNotifier {
  @override
  Locale? build() => const Locale('en');
}
