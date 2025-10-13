import 'package:flutter/material.dart';
import '../../core/constants/app_color.dart';

class AppSwitcher extends StatelessWidget {
  final double? size;
  final void Function(bool) onChanged;
  final bool value;
  const AppSwitcher(
      {super.key, required this.onChanged, required this.value, this.size});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: size ?? 0.85,
      child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColor.subtextColor,
          activeTrackColor: AppColor.subtextColor.withOpacity(0.35),
          inactiveThumbColor: AppColor.black.withOpacity(0.3),
          inactiveTrackColor: AppColor.black.withOpacity(0.1),
          trackOutlineColor:
              WidgetStateColor.resolveWith((states) => AppColor.noColor)),
    );
  }
}