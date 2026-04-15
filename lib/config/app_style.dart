enum PortfolioStyle { startup, classic }

class AppStyle {
  static const PortfolioStyle activeStyle = PortfolioStyle.startup;

  static bool get isStartup => activeStyle == PortfolioStyle.startup;
  static bool get isClassic => activeStyle == PortfolioStyle.classic;

  static double get heroFontSize => isStartup ? 72.0 : 56.0;
  static double get sectionPadding => isStartup ? 100.0 : 80.0;
  static double get cardRadius => isStartup ? 20.0 : 8.0;
  static bool get useAnimations => isStartup;
  static bool get useGlowEffects => isStartup;
  static bool get useGradientText => isStartup;
  static double get navBlur => isStartup ? 20.0 : 0.0;
}
