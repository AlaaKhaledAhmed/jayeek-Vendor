import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_color.dart';
import '../../core/constants/app_size.dart';
import '../widgets/app_text.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final List<Widget>? actions;
  final bool? showActions;
  final bool? centerTitle;

  ///if true, it hides the back button from the app bar
  final bool? hideBackButton;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? leading;
  final Color? actionColor;
  final double? leadingWidth;
  final double? fontSize;
  final double? elevation;
  final Widget? child;
  const AppBarWidget({
    super.key,
    this.text='',
    this.actions,
    this.showActions,
    this.backgroundColor,
    this.textColor,
    this.centerTitle,
    this.leading,
    this.actionColor,
    this.leadingWidth,
    this.fontSize,
    this.elevation,
    this.hideBackButton=true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation ?? 1,
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: centerTitle ?? false,
        surfaceTintColor: AppColor.white,
        backgroundColor: (backgroundColor ?? AppColor.mainColor),
        title: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child:
              child ??
              AppText(
                text: text,
                fontSize: fontSize ?? AppSize.appBarTitleSize,
                color: textColor ?? AppColor.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: leading,
        leadingWidth: leadingWidth,
        actions:
            hideBackButton == true
                ? null
                : actions ??
                    [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: actionColor ?? AppColor.white,
                          size: AppSize.appBarIconSize,
                        ),
                      ),
                    ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(
    AppSize.appBarHeight,
    //kToolbarHeight
  );
}
