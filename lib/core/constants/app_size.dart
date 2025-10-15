import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSize {
  //singleton class
  AppSize._();

  ///Checks if the current screen width is considered large (e.g., tablet or desktop).
  static bool get isLargeScreen => 1.sw > 600;

  ///Helper method that increases a given size 25% if screen is large.
  static double scale(double base) {
    return isLargeScreen ? base * 1.3 : base;
  }

  // ─────────────────────────────────────────────
  // 📏 Text Sizes
  // ─────────────────────────────────────────────

  static double get heading1 => scale(24.spMin);
  static double get headingBig => scale(30.spMin);
  static double get heading2 => scale(18.spMin);
  static double get heading3 => scale(20.spMin);
  static double get normalText => scale(15.spMin);
  static double get bodyText => scale(16.spMin);
  static double get captionText => scale(14.spMin);
  static double get smallText => scale(12.spMin);
  static double get buttonFontSize => scale(14.5.spMin);
  static double get appBarTitleSize => scale(20.spMin);

  // ─────────────────────────────────────────────
  // 🧭 Icon Sizes
  // ─────────────────────────────────────────────

  static double get iconSize => scale(24.spMin);
  static double get mediumIconSize => scale(20.spMin);
  static double get smallIconSize => scale(16.spMin);
  static double get largeIconSize => scale(35.spMin);
  static double get veryLargeIconSize => scale(50.spMin);
  static double get appBarIconSize => scale(26.spMin);

  // ─────────────────────────────────────────────
  // 🔲 Paddings & Margins
  // ─────────────────────────────────────────────

  static double get defaultPadding => 16.spMin;

  static double get horizontalPadding => 10.w;

  // ─────────────────────────────────────────────
  // 🔘 Buttons
  // ─────────────────────────────────────────────

  static double get buttonHeight => 50.h;
  static double get buttonWidth => 200.w;
  static double get buttonRadius => 50.r;

  // ─────────────────────────────────────────────
  // 🧾 AppBar
  // ─────────────────────────────────────────────

  static double get appBarHeight => 65.h;
  static double get appBarSmallHeight => 60.h;

  // ─────────────────────────────────────────────
  // 🧍‍♂️ Inputs
  // ─────────────────────────────────────────────

  static double get inputFieldHeight => 48.h;

  // ─────────────────────────────────────────────
  // 📐 Screen Dimensions
  // ─────────────────────────────────────────────

  static double get screenHeight => 1.sh;
  static double get screenWidth => 1.sw;
}
