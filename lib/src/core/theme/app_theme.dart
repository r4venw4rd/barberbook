import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme_builder.dart';

export 'package:hair_dryer_app/src/core/theme/app_theme_extras.dart';
export 'package:hair_dryer_app/src/core/theme/app_theme_tokens.dart';

/// Builds and caches the light and dark [ThemeData] used by the app.
abstract final class AppTheme {
  static final ThemeData lightTheme = buildAppTheme(Brightness.light);
  static final ThemeData darkTheme = buildAppTheme(Brightness.dark);

  /// Light theme.
  static ThemeData light() => lightTheme;

  /// Dark theme.
  static ThemeData dark() => darkTheme;
}
