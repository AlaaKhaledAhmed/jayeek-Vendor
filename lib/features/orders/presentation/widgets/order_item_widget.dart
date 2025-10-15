import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../data/models/order_model.dart';

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
      padding: EdgeInsets.all(12.w),
      decoration: AppDecoration.decoration(
        color: AppColor.backgroundColor,
        radius: 12.r,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image
          if (item.image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                item.image!,
                width: 60.w,
                height: 60.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60.w,
                    height: 60.w,
                    color: AppColor.borderColor,
                    child: Icon(
                      Icons.restaurant,
                      color: AppColor.subGrayText,
                      size: 30.sp,
                    ),
                  );
                },
              ),
            )
          else
            Container(
              width: 60.w,
              height: 60.w,
              decoration: AppDecoration.decoration(
                color: AppColor.white,
                radius: 8.r,
              ),
              child: Icon(
                Icons.restaurant,
                color: AppColor.subGrayText,
                size: 30.sp,
              ),
            ),

          SizedBox(width: 12.w),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name and Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        text: item.name,
                        fontSize: AppSize.normalText,
                        fontWeight: AppThem().bold,
                        color: AppColor.textColor,
                        maxLine: 2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: AppDecoration.decoration(
                        color: AppColor.mainColor.withOpacity(0.1),
                        radius: 6.r,
                      ),
                      child: AppText(
                        text: 'x${item.quantity}',
                        fontSize: AppSize.smallText,
                        fontWeight: AppThem().bold,
                        color: AppColor.mainColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6.h),

                // Addons
                if (item.addons != null && item.addons!.isNotEmpty) ...[
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    children: item.addons!
                        .map(
                          (addon) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: AppDecoration.decoration(
                              color: AppColor.white,
                              radius: 4.r,
                            ),
                            child: AppText(
                              text: '+ ${addon.name}',
                              fontSize: AppSize.captionText,
                              color: AppColor.subGrayText,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 6.h),
                ],

                // Notes
                if (item.notes != null && item.notes!.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notes,
                        size: 14.sp,
                        color: AppColor.subGrayText,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: AppText(
                          text: item.notes!,
                          fontSize: AppSize.captionText,
                          color: AppColor.subGrayText,
                          maxLine: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                ],

                // Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText(
                      text:
                          '${item.totalPrice.toStringAsFixed(2)} ${AppMessage.sar}',
                      fontSize: AppSize.normalText,
                      fontWeight: AppThem().bold,
                      color: AppColor.mainColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
