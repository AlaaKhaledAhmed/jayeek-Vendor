import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/theme/app_them.dart';
import 'package:jayeek_vendor/core/widgets/app_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_drop_list.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/custom_load.dart';
import 'package:jayeek_vendor/core/widgets/scroll_list.dart';
import '../../domain/models/menu_item_model.dart';
import '../../providers/menu/menu_provider.dart';
import '../../providers/update_item/update_item_provider.dart';
import '../widgets/addons_section.dart';
import '../widgets/food_menu_bottom_sheets.dart';
import '../widgets/meal_image_picker.dart';
import '../widgets/switch_row.dart';

class UpdateItemPage extends ConsumerWidget {
  final MenuItemModel item;

  const UpdateItemPage({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = updateItemProvider(item);
    final notifier = ref.read(provider.notifier);
    final state = ref.watch(provider);

    return Scaffold(
      appBar: const AppBarWidget(
        text: AppMessage.editMeal,
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
                      AppText(
                        text: AppMessage.mealName,
                        fontWeight: AppThem().bold,
                      ),
                      SizedBox(height: 5.h),
                      AppTextFields(
                        hintText: AppMessage.mealName,
                        controller: notifier.nameController,
                        validator: (v) =>
                            v!.isEmpty ? AppMessage.enterMealName : null,
                      ),
                      SizedBox(height: 10.h),

                      // الوصف
                      AppText(
                        text: AppMessage.description,
                        fontWeight: AppThem().bold,
                      ),
                      SizedBox(height: 5.h),
                      AppTextFields(
                        hintText: AppMessage.description,
                        controller: notifier.descriptionController,
                        minLines: 3,
                        maxLines: 4,
                        validator: (v) =>
                            v!.isEmpty ? AppMessage.enterDescription : null,
                      ),
                      SizedBox(height: 10.h),

                      // السعر
                      AppText(
                        text: AppMessage.price,
                        fontWeight: AppThem().bold,
                      ),
                      SizedBox(height: 5.h),
                      AppTextFields(
                        hintText: AppMessage.price,
                        keyboardType: TextInputType.number,
                        controller: notifier.priceController,
                        validator: (v) =>
                            v!.isEmpty ? AppMessage.enterMealPrice : null,
                      ),
                      SizedBox(height: 10.h),

                      // الفئة
                      AppText(
                        text: AppMessage.category,
                        fontWeight: AppThem().bold,
                      ),
                      SizedBox(height: 5.h),
                      AppDropList(
                        hintText: AppMessage.chooseCategory,
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
                              text: AppMessage.addNewCategory,
                              color: AppColor.accentColor,
                              fontWeight: AppThem().bold,
                            ),
                          ),
                        ),
                      SizedBox(height: 10.h),

                      // الفرع
                      AppText(
                        text: AppMessage.branch,
                        fontWeight: AppThem().bold,
                      ),
                      SizedBox(height: 5.h),
                      AppDropList(
                        hintText: AppMessage.chooseBranch,
                        items: state.branches,
                        value: notifier.selectedBranch,
                        onChanged: notifier.selectBranch,
                      ),
                      SizedBox(height: 10.h),

                      // السويتشات
                      SwitchRow(
                        label: AppMessage.canCustomize,
                        value: state.isCustomizable,
                        onChanged: notifier.toggleCustomizable,
                      ),
                      SwitchRow(
                        label: AppMessage.available,
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
                        text: AppMessage.saveChanges,
                        onPressed: () async {
                          final updatedItem = await notifier.update();
                          if (updatedItem != null && context.mounted) {
                            // Update in menu list
                            ref
                                .read(menuProvider.notifier)
                                .updateItem(updatedItem);
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
