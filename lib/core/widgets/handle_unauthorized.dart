import 'package:flutter/material.dart';
import '../../app/app.dart';
import '../../features/auth/presentation/screens/login_page.dart';
import '../routing/app_routes_methods.dart';

Widget handleUnauthorized() {
  final context = myNavigatorKey.currentContext!;
  Future.delayed(Duration.zero, () {
    AppRoutes.pushAndRemoveAllPageTo(
      context,
      const LoginScreen(),
      removeProviderData: true,
    );
  });
  return const SizedBox();
}
