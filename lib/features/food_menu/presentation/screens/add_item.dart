import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/theme/app_them.dart';
import 'package:jayeek_vendor/core/widgets/app_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_drop_list.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/custom_load.dart';
import 'package:jayeek_vendor/core/widgets/scroll_list.dart';
import '../../providers/add_item_provider.dart';
import '../../providers/menu/menu_provider.dart';
import '../widgets/addons_section.dart';
import '../widgets/food_menu_bottom_sheets.dart';
import '../widgets/meal_image_picker.dart';
import '../widgets/switch_row.dart';

/// AddItemPage - Refactored with clean architecture
/// All widgets extracted to separate files in widgets folder
class AddItemPage extends ConsumerWidget {
  const AddItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addItemProvider.notifier);
    final state = ref.watch(addItemProvider);

    return Scaffold(
      appBar: const AppBarWidget(
        text: 'إضافة وجبة جديدة',
        hideBackButton: false,
      ),
      body: state.isLoading
          ? CustomLoad().loadVerticalList(context: context)
          : SafeArea(
              child: Form(
                key: notifier.formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: ScrollList(
                    children: [
                      // صورة الوجبة
                      MealImagePicker(
                        path: state.mealImagePath,
                        onTap: () => notifier.pickMealImage(context),
                      ),
                      SizedBox(height: 12.h),

                      // اسم الوجبة
                      AppText(text: 'اسم الوجبة', fontWeight: AppThem().bold),
                      SizedBox(height: 5.h),
                      AppTextFields(
                        hintText: 'اسم الوجبة',
                        controller: notifier.nameController,
                        validator: (v) =>
                            v!.isEmpty ? 'يرجى إدخال الاسم' : null,
                      ),
                      SizedBox(height: 10.h),

                      // الوصف
                      AppText(text: 'الوصف', fontWeight: AppThem().bold),
                      SizedBox(height: 5.h),
                      AppTextFields(
                        hintText: 'الوصف',
                        controller: notifier.descriptionController,
                        minLines: 3,
                        maxLines: 4,
                        validator: (v) =>
                            v!.isEmpty ? 'يرجى إدخال الوصف' : null,
                      ),
                      SizedBox(height: 10.h),

                      // السعر
                      AppText(text: 'السعر', fontWeight: AppThem().bold),
                      SizedBox(height: 5.h),
                      AppTextFields(
                        hintText: 'السعر',
                        keyboardType: TextInputType.number,
                        controller: notifier.priceController,
                        validator: (v) =>
                            v!.isEmpty ? 'يرجى إدخال السعر' : null,
                      ),
                      SizedBox(height: 10.h),

                      // الفئة
                      AppText(text: 'الفئة', fontWeight: AppThem().bold),
                      SizedBox(height: 5.h),
                      AppDropList(
                        hintText: 'اختر الفئة',
                        items: state.categories,
                        value: notifier.selectedCategory,
                        onChanged: notifier.selectCategory,
                      ),
                      if (state.categories.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: InkWell(
                            onTap: () => FoodMenuBottomSheets.showAddCategory(
                              context,
                              onAdd: notifier.addNewCategory,
                            ),
                            child: AppText(
                              text: 'إضافة فئة جديدة',
                              color: AppColor.accentColor,
                              fontWeight: AppThem().bold,
                            ),
                          ),
                        ),
                      SizedBox(height: 10.h),

                      // الفرع
                      AppText(text: 'الفرع', fontWeight: AppThem().bold),
                      SizedBox(height: 5.h),
                      AppDropList(
                        hintText: 'اختر الفرع',
                        items: state.branches,
                        value: notifier.selectedBranch,
                        onChanged: notifier.selectBranch,
                      ),
                      SizedBox(height: 10.h),

                      // السويتشات
                      SwitchRow(
                        label: 'قابل للتخصيص',
                        value: state.isCustomizable,
                        onChanged: notifier.toggleCustomizable,
                      ),
                      SwitchRow(
                        label: 'متاح الآن',
                        value: state.isAvailable,
                        onChanged: notifier.toggleAvailable,
                      ),
                      SizedBox(height: 14.h),

                      // الإضافات (القوائم)
                      AddonsSection(
                        groups: state.addonGroups,
                        onAddGroup: () =>
                            FoodMenuBottomSheets.showCreateAddonGroup(
                              context,
                              onAdd: notifier.addAddonGroup,
                            ),
                        onDeleteGroup: notifier.deleteAddonGroup,
                        onAddItem: (gIndex) =>
                            FoodMenuBottomSheets.showAddAddonItem(
                              context,
                              onAdd: (item) =>
                                  notifier.addAddonItem(gIndex, item),
                            ),
                        onToggleRequired: notifier.setGroupRequired,
                        onMaxChange: notifier.setGroupMaxSelectable,
                        onDeleteItem: notifier.deleteAddonItem,
                      ),

                      SizedBox(height: 20.h),

                      // زر الحفظ
                      AppButtons(
                        text: 'حفظ الوجبة',
                        onPressed: () async {
                          final newItem = await notifier.submit();
                          if (newItem != null && context.mounted) {
                            // Add to menu list
                            ref.read(menuProvider.notifier).addItem(newItem);
                            Navigator.pop(context);
                          }
                        },
                        backgroundColor: AppColor.mainColor,
                        showLoader: state.isLoading,
                      ),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
