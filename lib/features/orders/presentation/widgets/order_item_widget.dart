import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/app_decoration.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/order_model.dart';
import 'order_item_components/item_addons_section.dart';
import 'order_item_components/item_header_row.dart';
import 'order_item_components/item_image_section.dart';
import 'order_item_components/item_notes_section.dart';
import 'order_item_components/item_total_footer.dart';

/// Widget عرض منتج في الطلب - مقسم إلى مكونات منفصلة
/// يستخدم نفس هيكلية الوجبات في عرض الإضافات
class OrderItemWidget extends StatelessWidget {
  final OrderItemModel item;

  const OrderItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: AppDecoration.decoration(
        color: AppColor.white,
        radius: 12.r,
        showBorder: true,
        borderColor: AppColor.borderColor.withOpacity(0.3),
        borderWidth: 1,
        shadow: false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainSection(),
          if (_hasAddons) ...[
            _buildDivider(),
            ItemAddonsSection(addons: item.addons!),
          ],
          if (_hasNotes) ...[
            _buildDivider(),
            ItemNotesSection(notes: item.notes!),
          ],
          ItemTotalFooter(
            totalPrice: item.totalPrice,
            hasNotes: _hasNotes,
          ),
        ],
      ),
    );
  }

  /// القسم الرئيسي - الصورة والمعلومات الأساسية
  Widget _buildMainSection() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemImageSection(imageUrl: item.image),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemHeaderRow(
                  itemName: item.name,
                  quantity: item.quantity,
                ),
                SizedBox(height: 8.h),
                _buildUnitPrice(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// عرض سعر الوحدة
  Widget _buildUnitPrice() {
    return Row(
      children: [
        AppText(
          text: 'السعر: ',
          fontSize: AppSize.captionText,
          color: AppColor.subGrayText,
        ),
        AppText(
          text: '${item.price.toStringAsFixed(2)} ${AppMessage.sar}',
          fontSize: AppSize.smallText,
          fontWeight: FontWeight.w600,
          color: AppColor.textColor,
        ),
      ],
    );
  }

  /// Divider بين الأقسام
  Widget _buildDivider() {
    return Divider(
      color: AppColor.borderColor.withOpacity(0.5),
      height: 1,
    );
  }

  /// التحقق من وجود إضافات
  bool get _hasAddons => item.addons != null && item.addons!.isNotEmpty;

  /// التحقق من وجود ملاحظات
  bool get _hasNotes => item.notes != null && item.notes!.isNotEmpty;
}
