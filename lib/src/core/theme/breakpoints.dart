import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class Breakpoints {
  // Width thresholds
  static const double mobileMax = 599;
  static const double tabletMin = 600;
  static const double tabletMax = 1023;
  static const double desktopMin = 1024;
  static const double desktopMax = 1439;
  static const double wideMin = 1440;

  // Max content width (web content is centered and constrained)
  static const double contentMaxWidth = 1200;

  // Spacing scale
  static const double spacingMobile = 16;
  static const double spacingTablet = 24;
  static const double spacingDesktop = 32;
}

// Helper extension on BuildContext
extension BreakpointContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isMobile => screenWidth <= Breakpoints.mobileMax;
  bool get isTablet =>
      screenWidth >= Breakpoints.tabletMin &&
      screenWidth <= Breakpoints.tabletMax;
  bool get isDesktop => screenWidth >= Breakpoints.desktopMin;
  bool get isWeb => kIsWeb;

  double get horizontalPadding => isMobile
      ? Breakpoints.spacingMobile
      : isTablet
      ? Breakpoints.spacingTablet
      : Breakpoints.spacingDesktop;
}
