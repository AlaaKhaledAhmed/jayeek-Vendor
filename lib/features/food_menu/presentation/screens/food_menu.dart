import 'package:flutter/material.dart';
import 'food_menu_with_tabs.dart';

/// FoodMenuScreen - Now uses tabs for meals and add-ons
/// Following the pattern used in auth feature
class FoodMenuScreen extends StatelessWidget {
  const FoodMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FoodMenuScreenWithTabs();
  }
}
