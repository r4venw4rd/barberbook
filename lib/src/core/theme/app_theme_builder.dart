import 'package:barberbook/src/core/theme/app_theme_controls.dart';
import 'package:barberbook/src/core/theme/app_theme_input.dart';
import 'package:barberbook/src/core/theme/app_theme_material.dart';
import 'package:barberbook/src/core/theme/app_theme_navigation.dart';
import 'package:barberbook/src/core/theme/app_theme_palette.dart';
import 'package:flutter/material.dart';

/// Composes the app's small theme builders into a complete Material theme.
ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme = AppThemePalette.colorScheme(brightness);
  final text = AppThemePalette.textTheme(brightness, scheme);
  final base = AppThemeMaterial.build(brightness, scheme, text);
  final withInputs = AppThemeInput.apply(base, isDark: isDark);
  final withNavigation = AppThemeNavigation.apply(
    withInputs,
    isDark: isDark,
    textTheme: text,
  );
  return AppThemeControls.apply(withNavigation, isDark: isDark);
}
