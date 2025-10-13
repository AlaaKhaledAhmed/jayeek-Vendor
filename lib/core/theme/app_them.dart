import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class AppThem {
  ///singleton class for app theme
  static final AppThem _instance = AppThem._internal();
  factory AppThem() => _instance;

  AppThem._internal();

  final String _fontFamily = 'Cairo';
  final FontWeight light = FontWeight.w300;
  final FontWeight regular = FontWeight.w400; // Cairo-Regular
  final FontWeight bold = FontWeight.w700; // Cairo-Bold

  String get fontFamily => _fontFamily;
  FontWeight get lightWeight => light;
  FontWeight get regularWeight => regular;
  FontWeight get boldWeight => bold;

  getAppThem() {
    return ThemeData(
      dividerTheme: const DividerThemeData(
        color: AppColor.lightGray,
        thickness: 0.8,
      ),
      primaryColor: AppColor.mainColor,
      scaffoldBackgroundColor: AppColor.scaffoldColor,
      useMaterial3: true,
      fontFamily: fontFamily,
    );
  }
}
