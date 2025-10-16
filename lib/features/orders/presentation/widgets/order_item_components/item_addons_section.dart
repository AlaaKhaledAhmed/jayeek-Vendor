import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';

/// قسم الإضافات - يعرض قائمة الإضافات مع الأسعار
class ItemAddonsSection extends StatelessWidget {
  final List<OrderAddonModel> addons;

  const ItemAddonsSection({
    super.key,
    required this.addons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: 16.sp,
                color: AppColor.subtextColor,
              ),
              SizedBox(width: 6.w),
              AppText(
                text: 'الإضافات',
                fontSize: AppSize.smallText,
                fontWeight: FontWeight.w600,
                color: AppColor.subtextColor,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: addons.map((addon) => _buildAddonChip(addon)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddonChip(OrderAddonModel addon) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: AppDecoration.decoration(
        color: AppColor.backgroundColor,
        radius: 6.r,
        showBorder: true,
        borderColor: AppColor.subtextColor.withOpacity(0.2),
        borderWidth: 1,
        shadow: false,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_rounded,
            size: 12.sp,
            color: AppColor.subtextColor,
          ),
          SizedBox(width: 4.w),
          AppText(
            text: addon.name,
            fontSize: AppSize.captionText,
            fontWeight: FontWeight.w600,
            color: AppColor.textColor,
          ),
          SizedBox(width: 6.w),
          AppText(
            text: '${addon.price.toStringAsFixed(2)} ر.س',
            fontSize: AppSize.captionText,
            fontWeight: AppThem().bold,
            color: AppColor.subtextColor,
          ),
        ],
      ),
    );
  }
}
