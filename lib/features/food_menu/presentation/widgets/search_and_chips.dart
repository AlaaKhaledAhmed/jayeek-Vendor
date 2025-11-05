import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/custom_load.dart';
import 'package:jayeek_vendor/core/widgets/data_view_builder.dart';
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
  bool _isCategorySelected(dynamic category, String? selectedCategory) {
    if (category == 'All') {
      return selectedCategory == null ||
          selectedCategory == 'All' ||
          selectedCategory == '';
    }
    if (category is String) {
      return selectedCategory == category;
    }
    // For FoodCategoryModel, compare by name
    if (category != null && category.name != null) {
      return selectedCategory == category.name;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(menuProvider);
    final notifier = ref.read(menuProvider.notifier);

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
          DataViewBuilder(
            dataHandle: state.categories,
            loadingBuilder: () => CustomLoad().boxLoad(height: 50.h),
            isDataEmpty: () => state.categories.data?.data?.isEmpty ?? true,
            onReload: () async => notifier.refreshMenu(),
            emptyBuilder: () => const SizedBox(),
            isSmallError: true,
            successBuilder: (model) {
              final categoriesList =
                  model.data?.where((cat) => cat.deleteFlag != true).toList() ??
                      [];

              const allCategories = ['All'];

              return SizedBox(
                height: 55.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: allCategories.length + categoriesList.length,
                  separatorBuilder: (_, __) => SizedBox(width: 2.w),
                  itemBuilder: (_, i) {
                    // First item is "All"
                    if (i == 0) {
                      final selected =
                          _isCategorySelected('All', state.category);
                      final icon = _getIcon('All');
                      return FilterChipWithIcon(
                        label: AppMessage.all,
                        icon: icon,
                        isSelected: selected,
                        onTap: () => notifier.setCategory('All'),
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
                          _isCategorySelected(category, state.category);
                      final categoryName = category.name ?? '';

                      return CategoryChipWithImage(
                        category: category,
                        isSelected: selected,
                        onTap: () => notifier.setCategory(categoryName),
                        selectedColor: AppColor.subtextColor,
                        borderRadius: 25,
                      );
                    }
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
