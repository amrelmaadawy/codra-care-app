import 'package:flutter/material.dart';

enum ScreenBreakpoint { mobile, tablet, desktop }

abstract final class ResponsiveUtils {
  static const double mobileMaxWidth = 600.0;
  static const double tabletMaxWidth = 1024.0;

  static ScreenBreakpoint of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < mobileMaxWidth) return ScreenBreakpoint.mobile;
    if (width < tabletMaxWidth) return ScreenBreakpoint.tablet;
    return ScreenBreakpoint.desktop;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == ScreenBreakpoint.mobile;

  static bool isTablet(BuildContext context) =>
      of(context) == ScreenBreakpoint.tablet;

  static bool isDesktop(BuildContext context) =>
      of(context) == ScreenBreakpoint.desktop;
}
