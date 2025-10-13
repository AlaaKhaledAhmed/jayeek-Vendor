import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/app_decoration.dart';
import '../widgets/app_text.dart';
import '../widgets/scroll_list.dart';

class ErrorScreen extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const ErrorScreen(this.errorDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ScrollList(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
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
          ],
        ),
      ),
    );
  }
}
