import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_text.dart';

/// Footer السعر الإجمالي للمنتج
class ItemTotalFooter extends StatelessWidget {
  final double totalPrice;
  final bool hasNotes;

  const ItemTotalFooter({
    super.key,
    required this.totalPrice,
    this.hasNotes = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.mainColor.withOpacity(0.05),
            AppColor.mainColor.withOpacity(0.02),
          ],
        ),
        borderRadius: hasNotes
            ? null
            : BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: 'الإجمالي',
            fontSize: AppSize.smallText,
            fontWeight: FontWeight.w600,
            color: AppColor.subGrayText,
          ),
          AppText(
            text: '${totalPrice.toStringAsFixed(2)} ${AppMessage.sar}',
            fontSize: AppSize.normalText,
            fontWeight: AppThem().bold,
            color: AppColor.mainColor,
          ),
        ],
      ),
    );
  }
}
