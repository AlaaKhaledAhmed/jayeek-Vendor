import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import '../screens/addons/update_addon.dart';
import '../screens/add_food.dart';

class AddMealOrAddonDialog extends StatelessWidget {
  const AddMealOrAddonDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddMealOrAddonDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: AppDecoration.decoration(
          color: AppColor.white,
          radius: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: AppMessage.addMeal,
              fontSize: AppSize.heading2,
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
            SizedBox(height: 16.h),
            AppText(
              text: 'اختر ما تريد إضافته',
              fontSize: AppSize.normalText,
              color: AppColor.subGrayText,
            ),
            SizedBox(height: 24.h),

            // Add Meal Button
            _buildOptionButton(
              context: context,
              icon: AppIcons.food,
              title: AppMessage.addMeal,
              subtitle: 'إضافة طبق جديد للقائمة',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFoodPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),

            // Add Addon Button
            _buildOptionButton(
              context: context,
              icon: AppIcons.addon,
              title: AppMessage.addAddon,
              subtitle: 'إضافة إضافة جديدة للقائمة',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateAddon(),
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),

            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: AppText(
                text: AppMessage.cancel,
                color: AppColor.mediumGray,
                fontSize: AppSize.normalText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: AppDecoration.decoration(
          color: AppColor.backgroundColor,
          radius: 12,
          showBorder: true,
          borderColor: AppColor.borderColor,
          borderWidth: 1,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: AppDecoration.decoration(
                color: AppColor.subtextColor.withOpacity(0.1),
                radius: 8,
              ),
              child: Icon(
                icon,
                color: AppColor.subtextColor,
                size: AppSize.largeIconSize,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    fontSize: AppSize.normalText,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textColor,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    text: subtitle,
                    fontSize: AppSize.smallText,
                    color: AppColor.subGrayText,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor.mediumGray,
              size: AppSize.smallIconSize,
            ),
          ],
        ),
      ),
    );
  }
}
