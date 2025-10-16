import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';

/// بطاقة معلومات العميل في صفحة التفاصيل
class CustomerInfoCard extends StatelessWidget {
  final OrderModel order;

  const CustomerInfoCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        color: AppColor.white,
        radius: 12.r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: AppMessage.customer,
            fontSize: AppSize.normalText,
            fontWeight: AppThem().bold,
            color: AppColor.textColor,
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(Icons.person_outline, order.customerName),
          SizedBox(height: 8.h),
          _buildInfoRow(Icons.phone_outlined, order.customerPhone),
          if (order.customerAddress != null) ...[
            SizedBox(height: 8.h),
            _buildInfoRow(Icons.location_on_outlined, order.customerAddress!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppColor.mainColor,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AppText(
            text: text,
            fontSize: AppSize.smallText,
            color: AppColor.textColor,
          ),
        ),
      ],
    );
  }
}
