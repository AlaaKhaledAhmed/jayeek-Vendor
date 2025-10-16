import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';

/// قسم معاينة المنتجات - يعرض عدد المنتجات ومعاينة سريعة
class ItemsPreviewSection extends StatelessWidget {
  final OrderModel order;

  const ItemsPreviewSection({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColor.subtextColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.restaurant_menu_rounded,
            size: 18.sp,
            color: AppColor.subtextColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: order.items.length > 1
                    ? '${order.items.length} ${AppMessage.items}'
                    : '${order.items.length} ${AppMessage.item}',
                fontSize: AppSize.smallText,
                fontWeight: FontWeight.w600,
                color: AppColor.textColor,
              ),
              SizedBox(height: 2.h),
              AppText(
                text: order.items.isNotEmpty
                    ? order.items.map((e) => e.name).take(2).join('، ')
                    : '',
                fontSize: AppSize.captionText,
                color: AppColor.subGrayText,
                maxLine: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
