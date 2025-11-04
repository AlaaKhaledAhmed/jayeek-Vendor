import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/routing/app_routes_methods.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';

import '../screens/categories/update_category.dart';

class CategoryEmptyState extends ConsumerWidget {
  const CategoryEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.food,
              size: AppSize.veryLargeIconSize,
              color: AppColor.mediumGray,
            ),
            SizedBox(height: 24.h),
            AppText(
              text: AppMessage.noCategoriesYet,
              fontSize: AppSize.heading2,
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
            SizedBox(height: 12.h),
            AppText(
              text: AppMessage.noCategoriesMessage,
              fontSize: AppSize.normalText,
              color: AppColor.subGrayText,
            ),
            SizedBox(height: 24.h),
            AppButtons(
              text: AppMessage.addCategory,
              onPressed: () async {
                AppRoutes.pushTo(context, const UpdateCategory(fromUpdate: false));
              },
              backgroundColor: AppColor.mainColor,
            ),
          ],
        ),
      ),
    );
  }
}

