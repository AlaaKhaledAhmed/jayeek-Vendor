import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/app_decoration.dart';
import '../widgets/app_text.dart';

class ErrorScreen extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const ErrorScreen(this.errorDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                decoration: AppDecoration.decoration(),
                child: AppText(
                  text:
                      kDebugMode
                          ? 'خطأ في التطبيق:\n\n${errorDetails.exceptionAsString()}'
                          : 'ERROR!!',
                  fontWeight: FontWeight.bold,
                  align: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
