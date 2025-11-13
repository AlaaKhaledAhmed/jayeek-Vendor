import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/filter_chip_with_icon.dart';
import '../../providers/menu/menu_provider.dart';
import 'category_chip_with_image.dart';

class SearchAndChips extends ConsumerStatefulWidget {
  const SearchAndChips({super.key});

  @override
  ConsumerState<SearchAndChips> createState() => _SearchAndChipsState();
}

class _SearchAndChipsState extends ConsumerState<SearchAndChips> {
  final _controller = TextEditingController();

  // Map categories to icons using AppIcons (for "All" category)
  final Map<String, IconData> _categoryIcons = {
    'All': AppIcons.allCategories,
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getIcon(String category) {
    return _categoryIcons[category] ?? AppIcons.food;
  }

  /// Check if category is selected
  bool _isCategorySelected(dynamic category, int? selectedCategoryId) {
    if (category == 'All') {
      return selectedCategoryId == null;
    }
    // For FoodCategoryModel, compare by id
    if (category != null && category.id != null) {
      return selectedCategoryId == category.id;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(menuProvider);
    final notifier = ref.read(menuProvider.notifier);

    // Get categories directly from state (no separate DataViewBuilder needed)
    final categoriesList = notifier
        .getCategories()
        .where((cat) => cat.deleteFlag != true)
        .toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextFields(
            validator: (c) => null,
            controller: _controller,
            hintText: AppMessage.searchForMeal,
            suffixIcon: const Icon(Icons.search),
            onChanged: notifier.setQuery,
          ),
          SizedBox(height: 12.h),
          // Categories chips - no DataViewBuilder needed since data comes from the same source
          SizedBox(
            height: 55.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: 1 + categoriesList.length, // "All" + categories
              separatorBuilder: (_, __) => SizedBox(width: 2.w),
              itemBuilder: (_, i) {
                // First item is "All"
                if (i == 0) {
                  final selected =
                      _isCategorySelected('All', state.selectedCategoryId);
                  final icon = _getIcon('All');
                  return FilterChipWithIcon(
                    label: AppMessage.all,
                    icon: icon,
                    isSelected: selected,
                    onTap: () => notifier.setCategory(null),
                    selectedColor: AppColor.subtextColor,
                    borderRadius: 25,
                  );
                }

                // API categories
                final categoryIndex = i - 1;
                if (categoryIndex >= 0 &&
                    categoryIndex < categoriesList.length) {
                  final category = categoriesList[categoryIndex];
                  final selected =
                      _isCategorySelected(category, state.selectedCategoryId);

                  return CategoryChipWithImage(
                    category: category,
                    isSelected: selected,
                    onTap: () => notifier.setCategory(category.id),
                    selectedColor: AppColor.subtextColor,
                    borderRadius: 25,
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
