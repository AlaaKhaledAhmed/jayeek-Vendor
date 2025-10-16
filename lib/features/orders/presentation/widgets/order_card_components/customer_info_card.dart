import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';

/// بطاقة معلومات العميل - تعرض الاسم والموقع
class CustomerInfoCard extends StatelessWidget {
  final OrderModel order;

  const CustomerInfoCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      decoration: AppDecoration.decoration(
        color: AppColor.white.withOpacity(0.9),
        radius: 8.r,
        shadow: false,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColor.mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 16.sp,
              color: AppColor.mainColor,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AppText(
              text: order.customerName,
              fontSize: AppSize.smallText,
              fontWeight: FontWeight.w600,
              color: AppColor.textColor,
              maxLine: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (order.customerAddress != null)
            Icon(
              Icons.location_on,
              size: 14.sp,
              color: AppColor.subGrayText,
            ),
        ],
      ),
    );
  }
}
