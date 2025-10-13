import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/routing/app_routes_methods.dart';
import 'package:jayeek_vendor/core/util/print_info.dart';
import 'package:jayeek_vendor/core/widgets/app_bar.dart';
import '../../providers/menu/menu_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/grid_list.dart';
import '../widgets/loading_placeholder.dart';
import '../widgets/search_and_chips.dart';
import '../widgets/vertical_list.dart';
import 'add_item.dart';

/// FoodMenuScreen - Refactored with clean architecture
/// Following the pattern used in auth feature
class FoodMenuScreen extends ConsumerWidget {
  const FoodMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(menuProvider);

    final filtered = state.items
        .where((e) {
          final q = state.query.trim().toLowerCase();
          final matchQuery =
              q.isEmpty ||
              e.name.toLowerCase().contains(q) ||
              e.description.toLowerCase().contains(q);
          final matchCat =
              state.category == null || e.category == state.category;
          return matchQuery && matchCat;
        })
        .toList(growable: false);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarWidget(
          text: AppMessage.foodMenu,
          hideBackButton: false,
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                printInfo('Navigate to Add Item');
                AppRoutes.pushTo(context, const AddItemPage());
              },
              icon: Icon(
                Icons.add_circle,
                color: AppColor.white,
                size: AppSize.largeIconSize,
              ),
            ),
          ],
        ),
        body: Column(
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
                          : VerticalList(items: filtered),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
