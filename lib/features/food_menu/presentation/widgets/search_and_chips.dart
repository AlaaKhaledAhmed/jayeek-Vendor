import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import '../../providers/menu/menu_provider.dart';

class SearchAndChips extends ConsumerStatefulWidget {
  const SearchAndChips({super.key});

  @override
  ConsumerState<SearchAndChips> createState() => _SearchAndChipsState();
}

class _SearchAndChipsState extends ConsumerState<SearchAndChips> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(menuProvider);
    final notifier = ref.read(menuProvider.notifier);

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
      child: Column(
        children: [
          AppTextFields(
            validator: (c) {
              return null;
            },
            controller: _controller,
            hintText: 'ابحث عن وجبة…',
            suffixIcon: const Icon(Icons.search),
            onChanged: notifier.setQuery,
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 40.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                final cat = notifier.categories[i];
                final selected = (state.category ?? 'All') == cat;
                return ChoiceChip(
                  label: AppText(
                    text: cat == 'All' ? 'الكل' : cat,
                    color: AppColor.textColor,
                  ),
                  selected: selected,
                  backgroundColor: AppColor.white,
                  selectedColor: AppColor.subtextColor,
                  onSelected: (_) => notifier.setCategory(cat),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemCount: notifier.categories.length,
            ),
          ),
        ],
      ),
    );
  }
}
