import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_string.dart';
import '../../../food_menu/presentation/screens/food_menu.dart';
import '../../../orders/presentation/screens/orders_list_screen.dart';
import '../../../profile/presentation/screens/profile.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  List<Widget> page = [
    const FoodMenuScreen(),
    const OrdersListScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColor.mainColor,
        selectedFontSize: AppSize.captionText,
        selectedItemColor: AppColor.white,
        unselectedItemColor: AppColor.mediumGray,
        unselectedFontSize: AppSize.smallText,
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        items: [
          navIcon(icon: AppIcons.food, label: AppMessage.foodMenu),
          navIcon(icon: AppIcons.orders, label: AppMessage.orders),
          navIcon(icon: AppIcons.profile, label: AppMessage.profile),
        ],
      ),
    );
  }

  /// === Bottom Navigation Bar Items ===
  navIcon({required IconData icon, required String label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: AppSize.appBarIconSize),
      label: label,
    );
  }

  /// === Page Controller ===
  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController?.animateToPage(
      selectedIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInCirc,
    );
  }
}
