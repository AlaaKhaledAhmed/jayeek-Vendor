import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import '../constants/app_color.dart';
import '../theme/app_them.dart';
import 'app_decoration.dart';
import 'app_text.dart';

class PrefixPhone extends StatelessWidget {
  const PrefixPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.r),
      decoration: AppDecoration.decoration(
        shadow: false,
        color: AppColor.lightGray.resolveOpacity(0.5),
        radius: 5,
      ),
      width: 60.w,
      alignment: Alignment.center,
      child: AppText(
        text: context.locale.toString() == 'en' ? '+966' : '966+',
        fontWeight: AppThem().bold,
      ),
    );
  }
}
