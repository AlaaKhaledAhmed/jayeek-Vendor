import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/bottom_sheet.dart';
import '../../providers/add_item_state.dart';
import 'switch_row.dart';

/// Helper class لعرض Bottom Sheets المشتركة بين صفحات إضافة وتعديل الوجبة
class FoodMenuBottomSheets {
  /// Bottom sheet لإضافة فئة جديدة
  static void showAddCategory(
    BuildContext context, {
    required Function(String) onAdd,
  }) {
    final ctrl = TextEditingController();
    CustomBottomSheet.show(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(text: 'إضافة فئة جديدة'),
          SizedBox(height: 10.h),
          AppTextFields(
            hintText: 'اسم الفئة',
            controller: ctrl,
            validator: (v) => v!.isEmpty ? 'أدخل الاسم' : null,
          ),
          SizedBox(height: 12.h),
          AppButtons(
            text: 'إضافة',
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                onAdd(ctrl.text.trim());
                Navigator.of(context).pop();
              }
            },
            backgroundColor: AppColor.mainColor,
          ),
        ],
      ),
    );
  }

  /// Bottom sheet لإنشاء مجموعة إضافات جديدة
  static void showCreateAddonGroup(
    BuildContext context, {
    required Function(AddonGroup) onAdd,
  }) {
    final nameCtrl = TextEditingController();
    bool required = false;
    final maxCtrl = TextEditingController();

    CustomBottomSheet.show(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(text: 'إنشاء قائمة إضافات'),
            SizedBox(height: 8.h),
            AppTextFields(
              hintText: 'اسم القائمة (مثال: الإضافات أو الصوصات)',
              controller: nameCtrl,
              validator: (v) => v!.isEmpty ? 'أدخل اسم القائمة' : null,
            ),
            SizedBox(height: 10.h),
            SwitchRow(
              label: 'إجبارية',
              value: required,
              onChanged: (v) => setState(() => required = v),
            ),
            if (!required) ...[
              SizedBox(height: 6.h),
              AppTextFields(
                hintText: 'الحد الأقصى للاختيار (رقم)',
                controller: maxCtrl,
                keyboardType: TextInputType.number,
                validator: (_) => null,
              ),
            ],
            SizedBox(height: 14.h),
            AppButtons(
              text: 'إنشاء',
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                final group = AddonGroup(
                  name: nameCtrl.text.trim(),
                  isRequired: required,
                  maxSelectable: required
                      ? null
                      : int.tryParse(
                          maxCtrl.text.trim().isEmpty
                              ? '0'
                              : maxCtrl.text.trim(),
                        ),
                );
                onAdd(group);
                Navigator.of(context).pop();
              },
              backgroundColor: AppColor.mainColor,
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom sheet لإضافة عنصر إلى مجموعة إضافات
  static void showAddAddonItem(
    BuildContext context, {
    required Function(AddonItem) onAdd,
  }) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');

    CustomBottomSheet.show(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: 'إضافة عنصر إلى القائمة',
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 8.h),
          AppTextFields(
            hintText: 'اسم العنصر',
            controller: nameCtrl,
            validator: (v) => v!.isEmpty ? 'أدخل الاسم' : null,
          ),
          SizedBox(height: 8.h),
          AppTextFields(
            hintText: 'السعر',
            keyboardType: TextInputType.number,
            controller: priceCtrl,
            validator: (v) => v!.isEmpty ? 'أدخل السعر' : null,
          ),
          SizedBox(height: 12.h),
          AppButtons(
            text: 'إضافة',
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty ||
                  priceCtrl.text.trim().isEmpty ||
                  qtyCtrl.text.trim().isEmpty)
                return;
              final item = AddonItem(
                name: nameCtrl.text.trim(),
                price: priceCtrl.text.trim(),
                quantity: qtyCtrl.text.trim(),
              );
              onAdd(item);
              Navigator.of(context).pop();
            },
            backgroundColor: AppColor.mainColor,
          ),
        ],
      ),
    );
  }
}
