import 'package:barberbook/src/core/theme/app_theme_builder.dart';
import 'package:flutter/material.dart';

export 'package:barberbook/src/core/theme/app_theme_extras.dart';
export 'package:barberbook/src/core/theme/app_theme_tokens.dart';

/// Builds and caches the light and dark [ThemeData] used by the app.
abstract final class AppTheme {
  static final ThemeData lightTheme = buildAppTheme(Brightness.light);
  static final ThemeData darkTheme = buildAppTheme(Brightness.dark);

  /// Light theme.
  static ThemeData light() => lightTheme;

  /// Dark theme.
  static ThemeData dark() => darkTheme;
}
