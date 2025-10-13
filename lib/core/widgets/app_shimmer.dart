import 'package:flutter/material.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_color.dart';

class AppShimmerWidget extends StatelessWidget {
  final Widget child;
  final bool enabled;
  const AppShimmerWidget({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.lightGray.resolveOpacity(0.4),
      highlightColor: AppColor.lightGray,
      direction: ShimmerDirection.rtl,
      enabled: enabled,
      child: child,
    );
  }
}
