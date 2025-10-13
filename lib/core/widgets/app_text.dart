
import 'package:flutter/material.dart';
import '../../core/constants/app_color.dart';
import '../constants/app_size.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextAlign? align;
  final Color? color;
  final TextOverflow? overflow;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final double? textHeight;
  final List<Shadow>? shadow;
  final TextDirection? textDirection;
  final bool? softWrap;
  final int? maxLine;
  const AppText({
    super.key,
    required this.text,
    this.align,
    this.color,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.textDecoration,
    this.textHeight,
    this.shadow,
    this.textDirection,
    this.softWrap,
    this.fontFamily,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      textDirection: textDirection,
      softWrap: softWrap,
      maxLines: maxLine,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize ?? AppSize.captionText,
        fontWeight: fontWeight,
        color: color ?? AppColor.textColor,
        decoration: textDecoration,
        decorationColor: AppColor.lightGray,
        height: textHeight,
        shadows: shadow,
        fontFamily: fontFamily,
      ),
    );
  }
}
