import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/extensions/color_extensions.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';

/// بطاقة عناصر الطلب بتصميم عصري مع عرض الإضافات
class OrderItemsCard extends StatelessWidget {
  final OrderModel order;

  const OrderItemsCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecoration.decoration(),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          const Divider(
            endIndent: 10,
            indent: 10,
            height: 5,
          ),
          // Items List
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              children: order.items
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              entry.key == order.items.length - 1 ? 0 : 12.h,
                        ),
                        child: _buildOrderItem(entry.value),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Header Section
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColor.subtextColor.resolveOpacity(0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              color: AppColor.subtextColor,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: AppMessage.orderItems,
                fontSize: AppSize.heading3,
                fontWeight: AppThem().bold,
                color: AppColor.textColor,
              ),
              SizedBox(height: 2.h),
              AppText(
                text: '${order.items.length} عنصر',
                fontSize: AppSize.captionText,
                color: AppColor.subGrayText,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Order Item Card
  Widget _buildOrderItem(OrderItemModel item) {
    final hasAddons = item.addons != null && item.addons!.isNotEmpty;
    final hasNotes = item.notes != null && item.notes!.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: AppDecoration.decoration(
        shadow: false,
        showBorder: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Header (Image, Name, Quantity, Price)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Image
              _buildItemImage(item.image),

              SizedBox(width: 12.w),

              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppText(
                            text: item.name,
                            fontSize: AppSize.normalText,
                            fontWeight: AppThem().bold,
                            color: AppColor.textColor,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.subtextColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: AppText(
                            text: 'x${item.quantity}',
                            fontSize: AppSize.captionText,
                            fontWeight: AppThem().bold,
                            color: AppColor.subtextColor,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6.h),

                    // Price
                    Row(
                      children: [
                        AppText(
                          text:
                              '${item.price.toStringAsFixed(2)} ${AppMessage.sar}',
                          fontSize: AppSize.smallText,
                          color: AppColor.subGrayText,
                        ),
                        if (hasAddons) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: AppColor.amber.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_circle_outline_rounded,
                                  size: 12.sp,
                                  color: AppColor.amber,
                                ),
                                SizedBox(width: 4.w),
                                AppText(
                                  text: '${item.addons!.length} إضافة',
                                  fontSize: AppSize.captionText,
                                  color: AppColor.amber,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Addons Section
          if (hasAddons) ...[
            SizedBox(height: 12.h),
            _buildAddonsSection(item.addons!),
          ],

          // Notes Section
          if (hasNotes) ...[
            SizedBox(height: 12.h),
            _buildNotesSection(item.notes!),
          ],

          // Item Total
          SizedBox(height: 12.h),
          Divider(color: AppColor.borderColor.withOpacity(0.5), height: 1),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'المجموع',
                fontSize: AppSize.smallText,
                color: AppColor.subGrayText,
                fontWeight: FontWeight.w600,
              ),
              AppText(
                text: '${item.totalPrice.toStringAsFixed(2)} ${AppMessage.sar}',
                fontSize: AppSize.normalText,
                fontWeight: AppThem().bold,
                color: AppColor.mainColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Item Image
  Widget _buildItemImage(String? imageUrl) {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColor.borderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: (imageUrl != null &&
                imageUrl.isNotEmpty &&
                imageUrl != 'string' &&
                imageUrl.length >= 3)
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppColor.subGrayText,
                  size: 32.sp,
                ),
              )
            : Icon(
                Icons.restaurant_menu_rounded,
                color: AppColor.subGrayText,
                size: 32.sp,
              ),
      ),
    );
  }

  /// Addons Section
  Widget _buildAddonsSection(List<OrderAddonModel> addons) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.amber.withOpacity(0.08),
            AppColor.amber.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColor.amber.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_circle_rounded,
                size: 16.sp,
                color: AppColor.amber,
              ),
              SizedBox(width: 6.w),
              AppText(
                text: 'الإضافات',
                fontSize: AppSize.captionText,
                fontWeight: AppThem().bold,
                color: AppColor.amber,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...addons.map((addon) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: BoxDecoration(
                            color: AppColor.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        AppText(
                          text: addon.name,
                          fontSize: AppSize.smallText,
                          color: AppColor.textColor,
                        ),
                      ],
                    ),
                    AppText(
                      text:
                          '+${addon.price.toStringAsFixed(2)} ${AppMessage.sar}',
                      fontSize: AppSize.captionText,
                      color: AppColor.amber,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  /// Notes Section
  Widget _buildNotesSection(String notes) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColor.borderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notes_rounded,
            size: 16.sp,
            color: AppColor.subGrayText,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AppText(
              text: notes,
              fontSize: AppSize.smallText,
              color: AppColor.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
