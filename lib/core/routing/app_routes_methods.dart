import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/login/login_provider.dart';
import '../../features/home/providers/home_provider.dart';
import '../../features/food_menu/providers/menu/menu_provider.dart';
import '../../features/food_menu/providers/add_item_provider.dart';
import '../../features/food_menu/providers/categories/categories_provider.dart';
import '../../features/food_menu/providers/custom_addon/custom_addon_provider.dart';
import '../../features/orders/providers/orders_list/orders_list_provider.dart';
import '../../features/orders/providers/order_details/order_details_provider.dart';

///Utility method for handling page transitions with optional animation

class AppRoutes {
  /// Push page with optional animation
  static void pushTo(
    BuildContext context,
    Widget page, {
    bool noAnimation = false,
  }) {
    final route = noAnimation
        ? MaterialPageRoute(builder: (_) => page)
        : _buildRoute(page);
    Navigator.push(context, route);
  }

  /// Push replacement page with optional animation
  static void pushReplacementTo(
    BuildContext context,
    Widget page, {
    bool noAnimation = false,
  }) {
    final route = noAnimation
        ? MaterialPageRoute(builder: (_) => page)
        : _buildRoute(page);

    Navigator.pushReplacement(context, route);
  }

  /// Push page and remove all previous routes with optional animation
  static void pushAndRemoveAllPageTo(
    BuildContext context,
    Widget page, {
    bool noAnimation = false,
    bool removeProviderData = false,
  }) {
    if (removeProviderData) {
      final container = ProviderScope.containerOf(context);

      /// Clear all providers data
      container.invalidate(loginProvider);
      container.invalidate(homeProvider);
      container.invalidate(menuProvider);
      container.invalidate(addItemProvider);
      container.invalidate(categoriesProvider);
      container.invalidate(customAddonProvider);
      container.invalidate(ordersListProvider);
      container.invalidate(orderDetailsProvider);
    }

    final route = noAnimation
        ? MaterialPageRoute(builder: (_) => page)
        : _buildRoute(page);

    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  /// Private method to build route with animation
  static PageRouteBuilder _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.linear;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
