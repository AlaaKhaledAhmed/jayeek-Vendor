import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/context_extensions.dart';
import '../../features/auth/presentation/screens/login_page.dart';
import '../constants/app_flow_sate.dart';
import '../constants/app_size.dart';
import '../constants/app_string.dart';
import '../error/app_error_message.dart';
import '../error/app_error_state.dart';
import '../model/data_handel.dart';
import '../routing/app_routes_methods.dart';
import 'app_buttons.dart';
import 'app_refresh_indicator.dart';
import 'app_text.dart';

class DataViewBuilder<T> extends StatelessWidget {
  final DataHandle<T> dataHandle;
  final Widget Function() loadingBuilder;
  final Widget Function() emptyBuilder;
  final Widget Function(T data) successBuilder;
  final bool Function() isDataEmpty;
  final Future<void> Function() onReload;
  final bool showAppBar;
  final bool isSmallError;
  final Decoration? decoration;
  final double? errorImageHeight;
  final Color? scaffoldColor;

  const DataViewBuilder({
    super.key,
    required this.dataHandle,
    required this.loadingBuilder,
    required this.successBuilder,
    required this.isDataEmpty,
    required this.onReload,
    required this.emptyBuilder,
    this.showAppBar = false,
    this.decoration,
    this.errorImageHeight,
    this.scaffoldColor,
    this.isSmallError = false,
  });

  @override
  Widget build(BuildContext context) {
    final result = dataHandle.result;

    ///om loading or initial show shimmer=======================================================================================================================
    if (result == AppFlowState.loading || result == AppFlowState.initial) {
      return loadingBuilder();
    }
    ///on token error=======================================================================================================================================
    else if (result == AppErrorState.unAuthorized) {
      ///use FutureBuilder if you wont using await inside build methods
      AppRoutes.pushAndRemoveAllPageTo(context, const LoginScreen());
      return const SizedBox();
    }
    ///on successful or pagination show data=============================================================================================================================================
    else if (result == AppFlowState.loaded ||
        result == AppFlowState.loadingMore) {
      if (isDataEmpty()) {
        return emptyBuilder();
      }
      return AppRefreshIndicator(
        onRefresh: onReload,
        child: successBuilder(dataHandle.data as T),
      );
    }

    ///on error show retry button=============================================================================================================================================
    return SizedBox(
      height: context.height,
      width: context.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15.h,
          children: [
            AppText(
              text: AppErrorMessage.getMessage(result),
              fontWeight: FontWeight.bold,
              align: TextAlign.center,
            ),
            AppButtons(
              text: AppMessage.tryAgain,
              height: AppSize.inputFieldHeight,
              onPressed: onReload,
            ),
          ],
        ),
      ),
    );
  }
}
