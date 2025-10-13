import 'package:flutter/material.dart';
import '../../core/constants/app_color.dart';
import '../../core/constants/app_size.dart';
import '../theme/app_them.dart';
import '../widgets/app_text.dart';
import 'custom_load.dart';

class AppButtons extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? textStyleColor;
  final FontWeight? textStyleWeight;
  final TextOverflow? overflow;
  final double? elevation;
  final double? width;
  final double? height;

  final double? textSize;
  final double? radius;
  final BorderSide? side;

  final AlignmentGeometry? alignment;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? buttonPadding;
  final BorderRadiusGeometry? borderRadius;
  final bool showLoader;
  const AppButtons({
    super.key,
    required this.text,
    required this.onPressed,

    this.backgroundColor,
    this.overflow,
    this.textStyleColor,
    this.textStyleWeight,
    this.width,
    this.elevation,
    this.height,

    this.textSize,
    this.radius,
    this.alignment,
    this.side,
    this.fontWeight,

    this.buttonPadding,
    this.borderRadius,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? AppSize.buttonHeight,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          alignment: alignment,
          shape: RoundedRectangleBorder(
            borderRadius:
            borderRadius ??
                BorderRadius.circular((radius ?? AppSize.buttonRadius)),
            side: side ?? const BorderSide(color: AppColor.noColor, width: 0.3),
          ),
          backgroundColor: (backgroundColor ?? AppColor.subtextColor),
          elevation: elevation ?? 0,
          padding: buttonPadding,
          textStyle: TextStyle(
            color: textStyleColor ?? Colors.white,
            fontSize: AppSize.buttonFontSize,
            fontWeight: fontWeight ?? AppThem().bold,
            fontFamily: AppThem().fontFamily,
          ),
        ),
        onPressed: showLoader ? null : onPressed,

        label:
        showLoader
            ? CustomLoad().circularLoad()
            : AppText(
          color: textStyleColor ?? Colors.white,
          fontSize: textSize ?? AppSize.buttonFontSize,
          fontWeight: fontWeight ?? AppThem().bold,
          fontFamily: AppThem().fontFamily,
          text: text,
          align: TextAlign.center,
        ),
      ),
    );
  }
}