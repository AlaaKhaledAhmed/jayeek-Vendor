import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/routing/app_routes_methods.dart';
import 'package:jayeek_vendor/core/theme/app_them.dart';
import 'package:jayeek_vendor/core/widgets/app_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/custom_load.dart';
import 'package:jayeek_vendor/core/widgets/data_view_builder.dart';
import 'package:jayeek_vendor/features/food_menu/presentation/screens/food/add_food.dart';

import '../../../providers/menu/menu_notifier.dart';
import '../../../providers/menu/menu_provider.dart';
import '../../../providers/menu/menu_state.dart';
import '../../widgets/empty_data.dart';
import '../../widgets/grid_list.dart';
import '../../widgets/menu_item_card.dart';
import '../../widgets/search_and_chips.dart';
import '../categories/categories_screen.dart';
import '../categories/update_category.dart';
import '../addons/addons_screen.dart';
import '../addons/update_addon.dart';

/// FoodMenuScreen with tabs for meals and add-ons
class FoodMenuScreenWithTabs extends ConsumerStatefulWidget {
  const FoodMenuScreenWithTabs({super.key});

  @override
  ConsumerState<FoodMenuScreenWithTabs> createState() =>
      _FoodMenuScreenWithTabsState();
}

class _FoodMenuScreenWithTabsState extends ConsumerState<FoodMenuScreenWithTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getAppBarTitle() {
    switch (_currentTabIndex) {
      case 0:
        return AppMessage.foodMenu;
      case 1:
        return AppMessage.categories;
      case 2:
        return AppMessage.addons;
      default:
        return AppMessage.foodMenu;
    }
  }

  VoidCallback _getAddButtonAction() {
    switch (_currentTabIndex) {
      case 0:
        return () {
          AppRoutes.pushTo(context, const AddFoodPage());
        };
      case 1:
        return () async {
          AppRoutes.pushTo(context, const UpdateCategory(fromUpdate: false));
        };
      case 2:
        return () async {
          AppRoutes.pushTo(context, const UpdateAddon(fromUpdate: false));
        };
      default:
        return () {};
    }
  }

  IconData _getAddButtonIcon() {
    return AppIcons.addon;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(menuProvider);
    final notifier = ref.read(menuProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarWidget(
          text: _getAppBarTitle(),
          hideBackButton: false,
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: _getAddButtonAction(),
              icon: Icon(
                _getAddButtonIcon(),
                color: AppColor.white,
                size: AppSize.largeIconSize,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Tab Bar
            ColoredBox(
              color: AppColor.scaffoldColor,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColor.subtextColor,
                labelColor: AppColor.subtextColor,
                unselectedLabelColor: AppColor.mediumGray,
                labelStyle: TextStyle(
                    fontSize: AppSize.normalText,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppThem().fontFamily),
                unselectedLabelStyle: TextStyle(
                    fontSize: AppSize.normalText,
                    fontWeight: FontWeight.normal,
                    fontFamily: AppThem().fontFamily),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          AppIcons.food,
                          size: AppSize.mediumIconSize,
                        ),
                        SizedBox(width: 8.w),
                        const AppText(text: AppMessage.meals),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          AppIcons.food,
                          size: AppSize.mediumIconSize,
                        ),
                        SizedBox(width: 8.w),
                        const AppText(text: AppMessage.categories),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          AppIcons.addon,
                          size: AppSize.mediumIconSize,
                        ),
                        SizedBox(width: 8.w),
                        const AppText(text: AppMessage.addons),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  /// Meals Tab
                  Column(
                    children: [
                      const SearchAndChips(),
                      Expanded(
                        child: _buildMenuItemsList(state, notifier),
                      ),
                    ],
                  ),

                  /// Categories Tab
                  const CategoriesScreen(),

                  /// Add-ons Tab
                  const AddonsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemsList(MenuState state, MenuNotifier notifier) {
    // Get items from response
    final items = state.items.data?.data ?? [];

    // Filter items based on query
    final filteredItems = items.where((item) {
      final q = (state.query ?? '').trim().toLowerCase();
      return q.isEmpty ||
          item.name.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q);
    }).toList(growable: false);

    return DataViewBuilder(
      dataHandle: state.items,
      loadingBuilder: () => CustomLoad().loadVerticalList(context: context),
      isDataEmpty: () => filteredItems.isEmpty,
      onReload: () async => notifier.refreshMenu(),
      emptyBuilder: () => const EmptyState(),
      successBuilder: (response) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: (state.gridMode ?? false)
            ? GridList(items: filteredItems)
            : ListView.separated(
                itemCount: filteredItems.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (_, i) {
                  final item = filteredItems[i];
                  return MenuItemCard(item: item);
                },
              ),
      ),
    );
  }
}
