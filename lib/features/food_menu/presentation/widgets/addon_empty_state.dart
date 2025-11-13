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

import '../screens/addons/update_addon.dart';

class AddonEmptyState extends ConsumerWidget {
  const AddonEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.addon,
              size: AppSize.veryLargeIconSize,
              color: AppColor.mediumGray,
            ),
            SizedBox(height: 24.h),
            AppText(
              text: AppMessage.noAddonsYet,
              fontSize: AppSize.heading2,
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
            SizedBox(height: 12.h),
            AppText(
              text: AppMessage.noAddonsMessage,
              fontSize: AppSize.normalText,
              color: AppColor.subGrayText,
            ),
            SizedBox(height: 24.h),
            AppButtons(
              text: AppMessage.addAddon,
              onPressed: () async {
                AppRoutes.pushTo(context, const UpdateAddon(fromUpdate: false));
              },
              backgroundColor: AppColor.mainColor,
            ),
          ],
        ),
      ),
    );
  }
}
