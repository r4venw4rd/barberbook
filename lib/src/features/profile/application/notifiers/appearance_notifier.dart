import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppearanceNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setMode(ThemeMode mode) {
    if (state != mode) {
      state = mode;
    }
  }
}

final appearanceProvider = NotifierProvider<AppearanceNotifier, ThemeMode>(
  AppearanceNotifier.new,
);
