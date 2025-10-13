import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/theme/app_them.dart';
import 'package:jayeek_vendor/core/widgets/app_switcher.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';

class SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(text: label, fontWeight: AppThem().bold),
          AppSwitcher(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
