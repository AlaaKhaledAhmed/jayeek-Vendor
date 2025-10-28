import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/util/print_info.dart';
import 'package:jayeek_vendor/core/widgets/app_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_refresh_indicator.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';

import '../../providers/menu/menu_provider.dart';
import '../../providers/custom_addon/custom_addon_provider.dart';
import '../widgets/add_meal_or_addon_dialog.dart';
import '../widgets/empty_data.dart';
import '../widgets/grid_list.dart';
import '../widgets/loading_placeholder.dart';
import '../widgets/search_and_chips.dart';
import '../widgets/vertical_list.dart';
import 'addons/addons_screen.dart';
import 'addons/update_addon.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
        return AppMessage.addons;
      default:
        return AppMessage.foodMenu;
    }
  }

  VoidCallback _getAddButtonAction() {
    switch (_currentTabIndex) {
      case 0:
        return () {
          printInfo('Show Add Meal Dialog');
          AddMealOrAddonDialog.show(context);
        };
      case 1:
        return () async {
          printInfo('Navigate to Add Addon');
          // Prepare for new addon before navigation
          ref.read(customAddonProvider.notifier).prepareForNewAddon();
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UpdateAddon(),
            ),
          );
          // Refresh addons list if addon was created successfully
          if (result == true) {
            ref.read(customAddonProvider.notifier).getCustomAddons();
          }
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

    final filtered = state.items.where((e) {
      final q = state.query.trim().toLowerCase();
      final matchQuery = q.isEmpty ||
          e.name.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q);
      final matchCat = state.category == null || e.category == state.category;
      return matchQuery && matchCat;
    }).toList(growable: false);

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
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: AppSize.normalText,
                  fontWeight: FontWeight.normal,
                ),
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
                        const AppText(text: AppMessage.all),
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
                        child: state.isLoading
                            ? const LoadingPlaceholder()
                            : filtered.isEmpty
                                ? const EmptyState()
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 8.h,
                                    ),
                                    child: state.gridMode
                                        ? GridList(items: filtered)
                                        : AppRefreshIndicator(
                                            onRefresh: ref
                                                .read(menuProvider.notifier)
                                                .refreshMenu,
                                            child:
                                                VerticalList(items: filtered),
                                          ),
                                  ),
                      ),
                    ],
                  ),

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
}
