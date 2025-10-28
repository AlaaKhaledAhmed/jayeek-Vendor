import 'package:flutter/material.dart';

import '../../features/home/presentation/screens/home_page.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../widgets/app_text.dart';

class RoutesNames {
  static const String splashScreen = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String otp = '/sing_up';
  static const String transactions = '/transactions';
}

///on generate route search for rout "/" if found return screen
///if not found return not found screen
///we don't use initialRoute with onGenerateRoute because onGenerateRoute
///can be called multiple times,its run "/" and then initalRoute
Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesNames.splashScreen:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case RoutesNames.home:
      return MaterialPageRoute(builder: (_) => const HomePage());

    default:
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: AppText(text: 'NOT FOUND'))),
      );
  }
}
