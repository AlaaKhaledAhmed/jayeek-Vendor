import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/app_color.dart';
import '../constants/app_size.dart';
import '../constants/app_string.dart';

import 'app_bar.dart';
import 'app_buttons.dart';
import 'app_text.dart';

class AppDialog {
  static showLoading({required context}) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            titlePadding: EdgeInsets.zero,
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: Container(
              alignment: AlignmentDirectional.center,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }

  static noPermissionDialog(
      {required BuildContext context,
      required String message,
      required String title}) {
    return showDialog(
        barrierDismissible: false,
        barrierColor: AppColor.black.withOpacity(0.3),
        context: context,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(15.r),
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(20.r)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    AppText(
                      text: title,
                      fontSize: AppSize.bodyText,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                      textDecoration: TextDecoration.none,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.r),
                      child: AppText(
                        text: message,
                        fontSize: AppSize.bodyText,
                        color: AppColor.black,
                        fontWeight: FontWeight.normal,
                        overflow: TextOverflow.visible,
                        align: TextAlign.center,
                        textDecoration: TextDecoration.none,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 3.w, right: 3.w, bottom: 10.h, top: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButtons(
                              height: 40.h,
                              width: 130.w,
                              onPressed: () async {
                                Navigator.pop(context);
                                await openAppSettings();
                              },
                              text: AppMessage.settings),
                          Padding(
                            padding: EdgeInsets.only(right: 10.h),
                            child: AppButtons(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              height: 40.h,
                              width: 130.w,
                              text: AppMessage.cancel,
                              backgroundColor: AppColor.accentColor,
                              textStyleColor: AppColor.mainColor,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  static infoDialogue({context, required Widget child}) {
    return showDialog(
        barrierDismissible: false,
        barrierColor: AppColor.black.withOpacity(0.3),
        context: context,
        builder: (_) {
          return child;
        });
  }

  static noPermissionWidget(context,
      {required String permissionTypeAr, Function(bool)? then}) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            children: [
              const AppBarWidget(
                text: '',
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  Icon(AppIcons.warning),
                  Transform.translate(
                    offset: Offset(0, -90.h),
                    child: Column(
                      children: [
                        const AppText(
                          text: AppMessage.enablePermission,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        AppText(
                          text: AppMessage.permissionRequest(
                              permissionType: permissionTypeAr),
                          overflow: TextOverflow.visible,
                          align: TextAlign.center,
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        AppButtons(
                            height: 40.h,
                            onPressed: () async {
                              await openAppSettings().then(then ?? (v) {});
                            },
                            text: AppMessage.goToSettings)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
