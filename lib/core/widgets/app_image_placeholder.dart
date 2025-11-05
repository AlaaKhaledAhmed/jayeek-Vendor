import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';

import '../../generated/assets.dart';
import '../constants/app_color.dart';
import 'app_decoration.dart';

class AppImagePlaceholder extends StatelessWidget {
  const AppImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(40.spMin),
        decoration: AppDecoration.decoration(
          color: AppColor.lightGray.resolveOpacity(0.2),
          shadow: false,
        ),
        child: const Image(
          image: AssetImage(Assets.imagesDefault),
          color: AppColor.white,
        ));
  }
}
