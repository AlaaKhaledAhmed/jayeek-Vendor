import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/shared_image_picker.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/unified_bottom_sheet.dart';
import 'package:jayeek_vendor/core/services/image_picker_service.dart';
import '../../providers/add_item_state.dart';

/// Modern Addon Groups Manager Widget
/// Displays and manages addon groups when customizable is enabled
class AddonGroupsManager extends StatelessWidget {
  final dynamic notifier; // Can be AddItemNotifier or UpdateItemNotifier
  final dynamic state; // Can be AddItemState or UpdateItemState
  
  const AddonGroupsManager({
    super.key,
    required this.notifier,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (!state.isCustomizable) {
      return const SizedBox.shrink();
    }

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
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.1),
                      Colors.purple.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.add_shopping_cart,
                  size: 20.sp,
                  color: Colors.purple,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppText(
                  text: AppMessage.addonGroups,
                  fontSize: AppSize.heading3,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textColor,
                ),
              ),
              AppButtons(
                text: '+ إضافة',
                onPressed: () => _showCreateGroupDialog(context),
                height: 36.h,
                backgroundColor: Colors.purple,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (state.addonGroups.isEmpty)
            _buildEmptyState(context)
          else
            ...state.addonGroups.asMap().entries.map((entry) {
              final index = entry.key;
              final group = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildGroupCard(context, index, group),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppColor.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColor.lightGray,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48.sp,
            color: AppColor.mediumGray,
          ),
          SizedBox(height: 12.h),
          AppText(
            text: 'لا توجد مجموعات إضافات',
            fontSize: AppSize.normalText,
            color: AppColor.subGrayText,
          ),
          SizedBox(height: 8.h),
          AppText(
            text: 'اضغط على "+ إضافة" لإنشاء مجموعة جديدة',
            fontSize: AppSize.smallText,
            color: AppColor.mediumGray,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, int groupIndex, AddonGroup group) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.lightGray,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.mainColor.withOpacity(0.1),
                  AppColor.mainColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: group.title,
                        fontSize: AppSize.bodyText,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textColor,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          _buildChip(
                            label: group.isSingleSelection
                                ? AppMessage.singleSelection
                                : AppMessage.multipleSelection,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 6.w),
                          if (!group.isSingleSelection && group.maxSelectable != null)
                            _buildChip(
                              label: 'حد أقصى: ${group.maxSelectable}',
                              color: Colors.orange,
                            ),
                          SizedBox(width: 6.w),
                          if (group.allowQuantity)
                            _buildChip(
                              label: 'كمية',
                              color: Colors.green,
                            ),
                          SizedBox(width: 6.w),
                          _buildChip(
                            label: group.isRequired
                                ? AppMessage.required
                                : AppMessage.optional,
                            color: group.isRequired ? Colors.red : Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Edit Button
                IconButton(
                  onPressed: () => _showEditGroupDialog(context, groupIndex, group),
                  icon: Icon(Icons.edit, size: 20.sp, color: AppColor.mainColor),
                ),
                // Delete Button
                IconButton(
                  onPressed: () => _showDeleteGroupDialog(context, groupIndex),
                  icon: Icon(Icons.delete, size: 20.sp, color: AppColor.red),
                ),
              ],
            ),
          ),
          // Group Items
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: AppMessage.addonItems,
                      fontSize: AppSize.normalText,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textColor,
                    ),
                    AppButtons(
                      text: '+ خيار',
                      onPressed: () => _showAddItemDialog(context, groupIndex),
                      height: 32.h,
                      backgroundColor: AppColor.mainColor,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                if (group.items.isEmpty)
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColor.lightGray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16.sp, color: AppColor.mediumGray),
                        SizedBox(width: 8.w),
                        AppText(
                          text: AppMessage.noItems,
                          fontSize: AppSize.smallText,
                          color: AppColor.subGrayText,
                        ),
                      ],
                    ),
                  )
                else
                  ...group.items.asMap().entries.map((entry) {
                    final itemIndex = entry.key;
                    final item = entry.value;
                    return _buildItemCard(context, groupIndex, itemIndex, item, group);
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({required String label, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: AppText(
        text: label,
        fontSize: AppSize.smallText,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    int groupIndex,
    int itemIndex,
    AddonItem item,
    AddonGroup group,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.lightGray),
      ),
      child: Row(
        children: [
          // Item Image
          if (item.image != null && item.image!.isNotEmpty)
            Container(
              width: 60.w,
              height: 60.h,
              margin: EdgeInsets.only(left: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColor.lightGray),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _buildItemImage(item.image!),
              ),
            )
          else
            Container(
              width: 60.w,
              height: 60.h,
              margin: EdgeInsets.only(left: 12.w),
              decoration: BoxDecoration(
                color: AppColor.lightGray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.image, size: 24.sp, color: AppColor.mediumGray),
            ),
          // Item Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: item.name,
                  fontSize: AppSize.normalText,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor,
                ),
                if (item.description != null && item.description!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  AppText(
                    text: item.description!,
                    fontSize: AppSize.smallText,
                    color: AppColor.subGrayText,
                  ),
                ],
                SizedBox(height: 4.h),
                Row(
                  children: [
                    AppText(
                      text: '${item.price} ر.س',
                      fontSize: AppSize.smallText,
                      fontWeight: FontWeight.bold,
                      color: AppColor.mainColor,
                    ),
                    if (group.allowQuantity) ...[
                      SizedBox(width: 8.w),
                      AppText(
                        text: '• الكمية: ${item.quantity}',
                        fontSize: AppSize.smallText,
                        color: AppColor.subGrayText,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _showEditItemDialog(context, groupIndex, itemIndex, item, group),
                icon: Icon(Icons.edit, size: 18.sp, color: AppColor.mainColor),
                padding: EdgeInsets.all(4.w),
              ),
              IconButton(
                onPressed: () => _showDeleteItemDialog(context, groupIndex, itemIndex),
                icon: Icon(Icons.delete, size: 18.sp, color: AppColor.red),
                padding: EdgeInsets.all(4.w),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(String imagePath) {
    try {
      if (imagePath.startsWith('http')) {
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: AppColor.mediumGray),
        );
      } else {
        final bytes = base64Decode(
          imagePath.contains(',') ? imagePath.split(',').last : imagePath,
        );
        return Image.memory(bytes, fit: BoxFit.cover);
      }
    } catch (e) {
      return Icon(Icons.broken_image, color: AppColor.mediumGray);
    }
  }

  void _showCreateGroupDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    bool isSingleSelection = false;
    bool isRequired = false;
    bool allowQuantity = false;
    final maxSelectableCtrl = TextEditingController();

    UnifiedBottomSheet.showCustom(
      context: context,
      title: AppMessage.createAddonGroup,
      height: MediaQuery.of(context).size.height * 0.85,
      child: StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              AppText(
                text: '${AppMessage.groupTitle} *',
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              AppTextFields(
                hintText: AppMessage.groupTitle,
                controller: titleCtrl,
                validator: (v) => null,
              ),
              SizedBox(height: 20.h),

              // Selection Type
              AppText(
                text: AppMessage.selectionType,
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectionTypeCard(
                      context: context,
                      label: AppMessage.singleSelection,
                      icon: Icons.radio_button_checked,
                      isSelected: isSingleSelection,
                      onTap: () => setState(() => isSingleSelection = true),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildSelectionTypeCard(
                      context: context,
                      label: AppMessage.multipleSelection,
                      icon: Icons.check_box,
                      isSelected: !isSingleSelection,
                      onTap: () => setState(() => isSingleSelection = false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Max Selectable (only if multiple)
              if (!isSingleSelection) ...[
                AppText(
                  text: '${AppMessage.maxSelectable} (${AppMessage.optional})',
                  fontSize: AppSize.bodyText,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                AppTextFields(
                  hintText: AppMessage.maxSelectable,
                  controller: maxSelectableCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => null,
                ),
                SizedBox(height: 20.h),
              ],

              // Allow Quantity
              _buildSwitchTile(
                title: AppMessage.allowQuantity,
                value: allowQuantity,
                onChanged: (v) => setState(() => allowQuantity = v),
                icon: Icons.numbers,
              ),
              SizedBox(height: 12.h),

              // Required
              _buildSwitchTile(
                title: AppMessage.required,
                value: isRequired,
                onChanged: (v) => setState(() => isRequired = v),
                icon: Icons.flag,
              ),
              SizedBox(height: 32.h),

              // Save Button
              AppButtons(
                text: AppMessage.add,
                onPressed: () {
                  if (titleCtrl.text.trim().isEmpty) return;
                  final group = AddonGroup(
                    title: titleCtrl.text.trim(),
                    isSingleSelection: isSingleSelection,
                    maxSelectable: isSingleSelection
                        ? null
                        : (maxSelectableCtrl.text.trim().isEmpty
                            ? null
                            : int.tryParse(maxSelectableCtrl.text.trim())),
                    allowQuantity: allowQuantity,
                    isRequired: isRequired,
                  );
                  notifier.addAddonGroup(group);
                  Navigator.pop(context);
                },
                backgroundColor: AppColor.mainColor,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionTypeCard({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.mainColor.withOpacity(0.1)
              : AppColor.lightGray.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColor.mainColor : AppColor.lightGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32.sp,
              color: isSelected ? AppColor.mainColor : AppColor.mediumGray,
            ),
            SizedBox(height: 8.h),
            AppText(
              text: label,
              fontSize: AppSize.normalText,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColor.mainColor : AppColor.textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: value ? AppColor.mainColor.withOpacity(0.05) : AppColor.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: value ? AppColor.mainColor.withOpacity(0.3) : AppColor.lightGray,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: value ? AppColor.mainColor : AppColor.mediumGray),
          SizedBox(width: 12.w),
          Expanded(
            child: AppText(
              text: title,
              fontSize: AppSize.normalText,
              fontWeight: FontWeight.w500,
              color: AppColor.textColor,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.mainColor,
          ),
        ],
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context, int groupIndex, AddonGroup group) {
    final titleCtrl = TextEditingController(text: group.title);
    bool isSingleSelection = group.isSingleSelection;
    bool isRequired = group.isRequired;
    bool allowQuantity = group.allowQuantity;
    final maxSelectableCtrl = TextEditingController(
      text: group.maxSelectable?.toString() ?? '',
    );

    UnifiedBottomSheet.showCustom(
      context: context,
      title: AppMessage.editGroup,
      height: MediaQuery.of(context).size.height * 0.85,
      child: StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              AppText(
                text: '${AppMessage.groupTitle} *',
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              AppTextFields(
                hintText: AppMessage.groupTitle,
                controller: titleCtrl,
                validator: (v) => null,
              ),
              SizedBox(height: 20.h),

              // Selection Type
              AppText(
                text: AppMessage.selectionType,
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectionTypeCard(
                      context: context,
                      label: AppMessage.singleSelection,
                      icon: Icons.radio_button_checked,
                      isSelected: isSingleSelection,
                      onTap: () => setState(() => isSingleSelection = true),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildSelectionTypeCard(
                      context: context,
                      label: AppMessage.multipleSelection,
                      icon: Icons.check_box,
                      isSelected: !isSingleSelection,
                      onTap: () => setState(() => isSingleSelection = false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Max Selectable
              if (!isSingleSelection) ...[
                AppText(
                  text: '${AppMessage.maxSelectable} (${AppMessage.optional})',
                  fontSize: AppSize.bodyText,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                AppTextFields(
                  hintText: AppMessage.maxSelectable,
                  controller: maxSelectableCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => null,
                ),
                SizedBox(height: 20.h),
              ],

              // Allow Quantity
              _buildSwitchTile(
                title: AppMessage.allowQuantity,
                value: allowQuantity,
                onChanged: (v) => setState(() => allowQuantity = v),
                icon: Icons.numbers,
              ),
              SizedBox(height: 12.h),

              // Required
              _buildSwitchTile(
                title: AppMessage.required,
                value: isRequired,
                onChanged: (v) => setState(() => isRequired = v),
                icon: Icons.flag,
              ),
              SizedBox(height: 32.h),

              // Save Button
              AppButtons(
                text: AppMessage.save,
                onPressed: () {
                  if (titleCtrl.text.trim().isEmpty) return;
                  notifier.editAddonGroupTitle(groupIndex, titleCtrl.text.trim());
                  notifier.setGroupSelectionType(groupIndex, isSingleSelection);
                  notifier.setGroupRequired(groupIndex, isRequired);
                  notifier.setGroupAllowQuantity(groupIndex, allowQuantity);
                  if (!isSingleSelection) {
                    notifier.setGroupMaxSelectable(
                      groupIndex,
                      maxSelectableCtrl.text.trim().isEmpty
                          ? null
                          : int.tryParse(maxSelectableCtrl.text.trim()),
                    );
                  }
                  Navigator.pop(context);
                },
                backgroundColor: AppColor.mainColor,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddItemDialog(
    BuildContext context,
    int groupIndex,
  ) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();
    final quantityCtrl = TextEditingController(text: '1');
    String? selectedImagePath;
    final group = state.addonGroups[groupIndex];

    UnifiedBottomSheet.showCustom(
      context: context,
      title: AppMessage.addItem,
      height: MediaQuery.of(context).size.height * 0.9,
      child: StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              AppText(
                text: '${AppMessage.itemImage}',
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              SharedImagePicker(
                imagePath: selectedImagePath,
                onPickImage: () async {
                  final path = await AppImagePicker.pickImageWithSource(context: context);
                  if (path != null) {
                    setState(() => selectedImagePath = path);
                  }
                },
                height: 150.h,
                borderRadius: 12,
                placeholderText: AppMessage.selectImage,
              ),
              SizedBox(height: 20.h),

              // Name
              AppText(
                text: '${AppMessage.itemName} *',
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              AppTextFields(
                hintText: AppMessage.itemName,
                controller: nameCtrl,
                validator: (v) => null,
              ),
              SizedBox(height: 16.h),

              // Description
              AppText(
                text: AppMessage.itemDescription,
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              AppTextFields(
                hintText: AppMessage.itemDescription,
                controller: descriptionCtrl,
                minLines: 2,
                maxLines: 3,
                validator: (v) => null,
              ),
              SizedBox(height: 16.h),

              // Price
              AppText(
                text: '${AppMessage.itemPrice} *',
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              AppTextFields(
                hintText: AppMessage.itemPrice,
                controller: priceCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (v) => null,
              ),
              SizedBox(height: 16.h),

              // Quantity (only if allowQuantity)
              if (group.allowQuantity) ...[
                AppText(
                  text: 'الكمية',
                  fontSize: AppSize.bodyText,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                AppTextFields(
                  hintText: 'الكمية',
                  controller: quantityCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => null,
                ),
                SizedBox(height: 16.h),
              ],

              // Save Button
              AppButtons(
                text: AppMessage.add,
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty || priceCtrl.text.trim().isEmpty) {
                    return;
                  }
                  final item = AddonItem(
                    name: nameCtrl.text.trim(),
                    price: priceCtrl.text.trim(),
                    description: descriptionCtrl.text.trim().isEmpty
                        ? null
                        : descriptionCtrl.text.trim(),
                    image: selectedImagePath,
                    quantity: group.allowQuantity
                        ? quantityCtrl.text.trim()
                        : '1',
                  );
                  notifier.addAddonItem(groupIndex, item);
                  Navigator.pop(context);
                },
                backgroundColor: AppColor.mainColor,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditItemDialog(
    BuildContext context,
    int groupIndex,
    int itemIndex,
    AddonItem item,
    AddonGroup group,
  ) {
    final nameCtrl = TextEditingController(text: item.name);
    final priceCtrl = TextEditingController(text: item.price);
    final descriptionCtrl = TextEditingController(text: item.description ?? '');
    final quantityCtrl = TextEditingController(text: item.quantity);
    String? selectedImagePath = item.image;

    UnifiedBottomSheet.showCustom(
      context: context,
      title: AppMessage.editItem,
      height: MediaQuery.of(context).size.height * 0.9,
      child: StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              AppText(
                text: '${AppMessage.itemImage}',
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              SharedImagePicker(
                imagePath: selectedImagePath,
                onPickImage: () async {
                  final path = await AppImagePicker.pickImageWithSource(context: context);
                  if (path != null) {
                    setState(() => selectedImagePath = path);
                  }
                },
                height: 150.h,
                borderRadius: 12,
                placeholderText: AppMessage.selectImage,
              ),
              SizedBox(height: 20.h),

              // Name
              AppText(
                text: '${AppMessage.itemName} *',
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              AppTextFields(
                hintText: AppMessage.itemName,
                controller: nameCtrl,
                validator: (v) => null,
              ),
              SizedBox(height: 16.h),

              // Description
              AppText(
                text: AppMessage.itemDescription,
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              AppTextFields(
                hintText: AppMessage.itemDescription,
                controller: descriptionCtrl,
                minLines: 2,
                maxLines: 3,
                validator: (v) => null,
              ),
              SizedBox(height: 16.h),

              // Price
              AppText(
                text: '${AppMessage.itemPrice} *',
                fontSize: AppSize.bodyText,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 8.h),
              AppTextFields(
                hintText: AppMessage.itemPrice,
                controller: priceCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (v) => null,
              ),
              SizedBox(height: 16.h),

              // Quantity (only if allowQuantity)
              if (group.allowQuantity) ...[
                AppText(
                  text: 'الكمية',
                  fontSize: AppSize.bodyText,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                AppTextFields(
                  hintText: 'الكمية',
                  controller: quantityCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => null,
                ),
                SizedBox(height: 16.h),
              ],

              // Save Button
              AppButtons(
                text: AppMessage.save,
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty || priceCtrl.text.trim().isEmpty) {
                    return;
                  }
                  final updatedItem = AddonItem(
                    name: nameCtrl.text.trim(),
                    price: priceCtrl.text.trim(),
                    description: descriptionCtrl.text.trim().isEmpty
                        ? null
                        : descriptionCtrl.text.trim(),
                    image: selectedImagePath,
                    quantity: group.allowQuantity
                        ? quantityCtrl.text.trim()
                        : '1',
                  );
                  notifier.editAddonItem(groupIndex, itemIndex, updatedItem);
                  Navigator.pop(context);
                },
                backgroundColor: AppColor.mainColor,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteGroupDialog(BuildContext context, int groupIndex) {
    UnifiedBottomSheet.showConfirmation(
      context: context,
      title: AppMessage.deleteGroup,
      message: 'هل أنت متأكد من حذف هذه المجموعة؟ سيتم حذف جميع الخيارات التابعة لها.',
      confirmText: AppMessage.delete,
      confirmColor: AppColor.red,
      onConfirm: () {
        notifier.deleteAddonGroup(groupIndex);
      },
    );
  }

  void _showDeleteItemDialog(BuildContext context, int groupIndex, int itemIndex) {
    UnifiedBottomSheet.showConfirmation(
      context: context,
      title: AppMessage.deleteItem,
      message: 'هل أنت متأكد من حذف هذا الخيار؟',
      confirmText: AppMessage.delete,
      confirmColor: AppColor.red,
      onConfirm: () {
        notifier.deleteAddonItem(groupIndex, itemIndex);
      },
    );
  }
}

