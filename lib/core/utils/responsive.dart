import 'package:flutter/material.dart';

enum Breakpoint { mobile, tablet, desktop }

class AppResponsive {
  AppResponsive._();

  static const double mobileBreak = 600;
  static const double tabletBreak = 1024;

  static Breakpoint of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < mobileBreak) return Breakpoint.mobile;
    if (w < tabletBreak) return Breakpoint.tablet;
    return Breakpoint.desktop;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == Breakpoint.mobile;

  static bool isTablet(BuildContext context) =>
      of(context) == Breakpoint.tablet;

  static bool isDesktop(BuildContext context) =>
      of(context) == Breakpoint.desktop;

  static bool isDesktopOrTablet(BuildContext context) =>
      of(context) != Breakpoint.mobile;

  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    switch (of(context)) {
      case Breakpoint.mobile:
        return mobile;
      case Breakpoint.tablet:
        return tablet ?? desktop;
      case Breakpoint.desktop:
        return desktop;
    }
  }

  static double maxWidth(BuildContext context) {
    return value(context, mobile: double.infinity, desktop: 1200.0);
  }

  static EdgeInsets pagePadding(BuildContext context) {
    return value(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 24),
      tablet: const EdgeInsets.symmetric(horizontal: 48),
      desktop: const EdgeInsets.symmetric(horizontal: 80),
    );
  }
}
