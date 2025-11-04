import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/widgets/app_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_drop_list.dart';
import 'package:jayeek_vendor/core/widgets/app_snack_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/custom_load.dart';
import 'package:jayeek_vendor/core/widgets/shared_image_picker.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import '../../../providers/add_item_provider.dart';
import '../../../providers/add_item_notifier.dart';
import '../../../providers/add_item_state.dart';
import '../../../providers/menu/menu_provider.dart';
import '../../../domain/models/food_category_model.dart';
import '../../widgets/addon_groups_manager.dart';

/// Modern Add Food Page with innovative design
class AddFoodPage extends ConsumerWidget {
  const AddFoodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addItemProvider.notifier);
    final state = ref.watch(addItemProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBarWidget(
        text: AppMessage.addMeal,
        hideBackButton: false,
      ),
      body: state.isLoading
          ? CustomLoad().loadVerticalList(context: context)
          : SafeArea(
              child: Form(
                key: notifier.formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modern Image Section with Card
                      _buildImageSection(context, notifier, state),
                      SizedBox(height: 24.h),

                      // Modern Input Fields in Cards
                      _buildInputCard(
                        title: '${AppMessage.mealName} *',
                        child: AppTextFields(
                          hintText: AppMessage.mealName,
                          controller: notifier.nameController,
                          validator: (v) =>
                              v!.isEmpty ? AppMessage.enterMealName : null,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      _buildInputCard(
                        title: '${AppMessage.description} *',
                        child: AppTextFields(
                          hintText: AppMessage.description,
                          controller: notifier.descriptionController,
                          minLines: 3,
                          maxLines: 4,
                          validator: (v) =>
                              v!.isEmpty ? AppMessage.enterDescription : null,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Price and Category in Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputCard(
                              title: '${AppMessage.price} *',
                              child: AppTextFields(
                                hintText: AppMessage.price,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                controller: notifier.priceController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                                validator: (v) {
                                  if (v!.isEmpty) return AppMessage.enterMealPrice;
                                  if (double.tryParse(v) == null || double.parse(v) <= 0) {
                                    return 'السعر يجب أن يكون أكبر من صفر';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildInputCard(
                              title: '${AppMessage.category} *',
                              child: AppDropList<FoodCategoryModel>(
                                hintText: AppMessage.chooseCategory,
                                items: state.categories,
                                value: notifier.selectedCategory,
                                onChanged: notifier.selectCategory,
                                customItem: state.categories
                                    .map(
                                      (category) => DropdownMenuItem<FoodCategoryModel>(
                                        value: category,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (category.image != null && category.image!.isNotEmpty)
                                              Builder(
                                                builder: (context) {
                                                  try {
                                                    final imageProvider = category.image!.startsWith('http')
                                                        ? NetworkImage(category.image!) as ImageProvider
                                                        : MemoryImage(base64Decode(
                                                            category.image!.contains(',') 
                                                                ? category.image!.split(',').last 
                                                                : category.image!));
                                                    return Container(
                                                      width: 24.w,
                                                      height: 24.h,
                                                      margin: EdgeInsets.only(left: 8.w),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(6.r),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  } catch (e) {
                                                    return SizedBox(width: 24.w, height: 24.h);
                                                  }
                                                },
                                              ),
                                            Flexible(
                                              child: AppText(
                                                text: category.nameAr ?? category.name ?? '',
                                                fontSize: AppSize.captionText,
                                                color: AppColor.textColor,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                                validator: (v) => v == null ? 'يرجى اختيار الفئة' : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Modern Toggle Switches Card
                      _buildToggleCard(
                        context: context,
                        notifier: notifier,
                        state: state,
                      ),
                      SizedBox(height: 24.h),

                      // Addon Groups Manager (only if customizable)
                      AddonGroupsManager(
                        notifier: notifier,
                        state: state,
                      ),
                      SizedBox(height: 32.h),

                      // Modern Save Button
                      _buildSaveButton(context, notifier, state, ref),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildImageSection(BuildContext context, AddItemNotifier notifier, AddItemState state) {
    return Container(
      decoration: AppDecoration.decoration(
        radius: 20,
        shadow: true,
        color: AppColor.white,
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.mainColor.withOpacity(0.1),
                      AppColor.mainColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image,
                      size: 16.sp,
                      color: AppColor.mainColor,
                    ),
                    SizedBox(width: 6.w),
                    AppText(
                      text: AppMessage.mealPhoto,
                      fontSize: AppSize.smallText,
                      fontWeight: FontWeight.w600,
                      color: AppColor.mainColor,
                    ),
                    AppText(
                      text: ' *',
                      fontSize: AppSize.smallText,
                      color: AppColor.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SharedImagePicker(
            imagePath: state.mealImagePath,
            onPickImage: () async {
              await notifier.pickMealImage(context);
            },
            height: 200.h,
            borderRadius: 16,
            placeholderText: 'اضغط لاختيار صورة الطبق',
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard({required String title, required Widget child}) {
    return Container(
      decoration: AppDecoration.decoration(
        radius: 16,
        shadow: true,
        color: AppColor.white,
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            fontSize: AppSize.bodyText,
            fontWeight: FontWeight.w600,
            color: AppColor.textColor,
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required BuildContext context,
    required AddItemNotifier notifier,
    required AddItemState state,
  }) {
    return Container(
      decoration: AppDecoration.decoration(
        radius: 16,
        shadow: true,
        color: AppColor.white,
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune_rounded,
                size: 20.sp,
                color: AppColor.mainColor,
              ),
              SizedBox(width: 8.w),
              AppText(
                text: 'الإعدادات',
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
                color: AppColor.textColor,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildModernSwitch(
            label: AppMessage.canCustomize,
            value: state.isCustomizable,
            onChanged: notifier.toggleCustomizable,
            icon: Icons.build_circle_outlined,
            color: Colors.purple,
          ),
          SizedBox(height: 16.h),
          _buildModernSwitch(
            label: AppMessage.available,
            value: state.isAvailable,
            onChanged: notifier.toggleAvailable,
            icon: Icons.check_circle_outline,
            color: AppColor.green,
          ),
        ],
      ),
    );
  }

  Widget _buildModernSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: value ? color.withOpacity(0.3) : AppColor.lightGray,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: value ? color.withOpacity(0.1) : AppColor.lightGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: value ? color : AppColor.mediumGray,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: AppText(
              text: label,
              fontSize: AppSize.normalText,
              fontWeight: FontWeight.w500,
              color: value ? AppColor.textColor : AppColor.subGrayText,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    AddItemNotifier notifier,
    AddItemState state,
    WidgetRef ref,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [
            AppColor.mainColor,
            AppColor.mainColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: AppButtons(
        text: AppMessage.save,
        onPressed: () async {
          // Check if image is selected
          if (state.mealImagePath == null ||
              state.mealImagePath!.isEmpty) {
            AppSnackBar.show(
              message: AppMessage.imageRequired,
              type: ToastType.error,
            );
            return;
          }

          final newItem = await notifier.submit();
          if (newItem != null && context.mounted) {
            // Add to menu list
            ref.read(menuProvider.notifier).addItem(newItem);
            Navigator.pop(context);
          }
        },
        backgroundColor: Colors.transparent,
        showLoader: state.isLoading,
        height: 56.h,
      ),
    );
  }
}
