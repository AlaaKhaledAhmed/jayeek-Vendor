import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/theme/app_them.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_switcher.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import '../../providers/add_item_state.dart';

class AddonsSection extends StatelessWidget {
  final List<AddonGroup> groups;
  final VoidCallback onAddGroup;
  final void Function(int index) onDeleteGroup;
  final void Function(int groupIndex) onAddItem;
  final void Function(int index, bool required) onToggleRequired;
  final void Function(int index, int? max) onMaxChange;
  final void Function(int groupIndex, int itemIndex) onDeleteItem;

  const AddonsSection({
    super.key,
    required this.groups,
    required this.onAddGroup,
    required this.onDeleteGroup,
    required this.onAddItem,
    required this.onToggleRequired,
    required this.onMaxChange,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(text: 'الإضافات', fontWeight: AppThem().bold),
            AppButtons(
              text: 'إضافة قائمة',
              onPressed: onAddGroup,
              backgroundColor: AppColor.subtextColor,
              height: 36.h,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        if (groups.isEmpty)
          Container(
            width: AppSize.screenWidth,
            decoration: AppDecoration.decoration(
              showBorder: true,
              shadow: false,
              radius: 5,
              borderWidth: 1.5,
            ),
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 5.w),
            child: const AppText(
              text: 'لا توجد قوائم إضافات بعد',
              color: AppColor.mediumGray,
            ),
          )
        else
          Column(
            children: List.generate(groups.length, (gIndex) {
              final g = groups[gIndex];
              return Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(10.w),
                decoration: AppDecoration.decoration(
                  showBorder: true,
                  shadow: false,
                  radius: 5,
                  borderWidth: 1.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // رأس القائمة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(text: g.name, fontWeight: AppThem().bold),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () => onAddItem(gIndex),
                              icon: Icon(
                                Icons.add_circle,
                                size: AppSize.appBarIconSize,
                                color: AppColor.mainColor,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            IconButton(
                              onPressed: () => onDeleteGroup(gIndex),
                              icon: Icon(
                                Icons.delete,
                                color: AppColor.mediumGray,
                                size: AppSize.appBarIconSize,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // required/optional + max
                    Row(
                      children: [
                        const AppText(text: 'إجبارية:'),
                        AppSwitcher(
                          value: g.isRequired,
                          onChanged: (v) => onToggleRequired(gIndex, v),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // العناصر
                    if (g.items.isEmpty)
                      const AppText(
                        text: 'لا توجد عناصر ضمن هذه القائمة',
                        color: AppColor.mediumGray,
                      )
                    else
                      Column(
                        children: List.generate(g.items.length, (iIndex) {
                          final it = g.items[iIndex];
                          return Container(
                            margin: EdgeInsets.only(bottom: 6.h),
                            padding: EdgeInsets.all(8.w),
                            decoration: AppDecoration.decoration(
                              radius: 5,
                              shadow: false,
                              showBorder: true,
                              borderWidth: 1,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: AppText(
                                text: it.name,
                                fontWeight: FontWeight.bold,
                              ),
                              subtitle: AppText(text: '${it.price} ريال'),
                              trailing: IconButton(
                                onPressed: () => onDeleteItem(gIndex, iIndex),
                                icon: CircleAvatar(
                                  radius: 15.r,
                                  backgroundColor: AppColor.accentColor,
                                  child: Icon(
                                    Icons.clear_rounded,
                                    size: AppSize.smallIconSize,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }
}
