import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/filter_chip_with_icon.dart';
import '../../providers/menu/menu_provider.dart';

class SearchAndChips extends ConsumerStatefulWidget {
  const SearchAndChips({super.key});

  @override
  ConsumerState<SearchAndChips> createState() => _SearchAndChipsState();
}

class _SearchAndChipsState extends ConsumerState<SearchAndChips> {
  final _controller = TextEditingController();

  // Map categories to icons using AppIcons
  final Map<String, IconData> _categoryIcons = {
    'All': AppIcons.allCategories,
    'Burgers': AppIcons.burgers,
    'Pasta': AppIcons.pasta,
    'Pizza': AppIcons.pizza,
    'Salads': AppIcons.salads,
    'Desserts': AppIcons.desserts,
    'Drinks': AppIcons.drinks,
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getIcon(String category) {
    return _categoryIcons[category] ?? AppIcons.food;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(menuProvider);
    final notifier = ref.read(menuProvider.notifier);

    return Container(
      color: AppColor.scaffoldColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
        child: Column(
          children: [
            AppTextFields(
              validator: (c) => null,
              controller: _controller,
              hintText: AppMessage.searchForMeal,
              suffixIcon: const Icon(Icons.search),
              onChanged: notifier.setQuery,
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 50.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: notifier.categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 2.w),
                itemBuilder: (_, i) {
                  final cat = notifier.categories[i];
                  final selected = (state.category ?? 'All') == cat;
                  final icon = _getIcon(cat);

                  return FilterChipWithIcon(
                    label: cat == 'All' ? AppMessage.all : cat,
                    icon: icon,
                    isSelected: selected,
                    onTap: () => notifier.setCategory(cat),
                    selectedColor: AppColor.subtextColor,
                    borderRadius: 25,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
