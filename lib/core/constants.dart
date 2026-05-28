class AppConstants {
  AppConstants._();

  static const double space2xs = 2;
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double space2xl = 48;
  static const double space3xl = 64;
  static const double space4xl = 96;

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static const double minButtonHeight = 44;
  static const double checkboxSize = 24;
  static const double bottomNavHeight = 64;
  static const double backButtonSize = 40;

  static const double radiusPill = 999;
  static const double radiusCard = 16;
  static const double radiusInput = 8;
  static const double radiusTechnical = 4;

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 200);
  static const Duration animationSlow = Duration(milliseconds: 300);

  static const String appName = 'Nothing Notes';
}

class RouteNames {
  RouteNames._();

  static const String home = 'home';
  static const String taskDetail = 'task-detail';
  static const String addTask = 'add-task';
  static const String settings = 'settings';
}
