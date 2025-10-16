import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/widgets/app_text.dart';

/// قسم الملاحظات - يعرض ملاحظات العميل على الطلب
class ItemNotesSection extends StatelessWidget {
  final String notes;

  const ItemNotesSection({
    super.key,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.amber.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColor.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              Icons.sticky_note_2_outlined,
              size: 14.sp,
              color: AppColor.amber,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'ملاحظات خاصة:',
                  fontSize: AppSize.captionText,
                  fontWeight: FontWeight.w600,
                  color: AppColor.amber.withOpacity(0.9),
                ),
                SizedBox(height: 2.h),
                AppText(
                  text: notes,
                  fontSize: AppSize.captionText,
                  color: AppColor.textColor,
                  maxLine: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
