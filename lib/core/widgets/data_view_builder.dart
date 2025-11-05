import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/extensions/context_extensions.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
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

class DataViewBuilder<T> extends StatefulWidget {
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
  State<DataViewBuilder<T>> createState() => _DataViewBuilderState<T>();
}

class _DataViewBuilderState<T> extends State<DataViewBuilder<T>> {
  bool _hasNavigated = false;

  @override
  void didUpdateWidget(DataViewBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset navigation flag if the dataHandle changed
    if (oldWidget.dataHandle.result != widget.dataHandle.result) {
      _hasNavigated = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.dataHandle.result;

    ///om loading or initial show shimmer=======================================================================================================================
    if (result == AppFlowState.loading || result == AppFlowState.initial) {
      return widget.loadingBuilder();
    }

    ///on token error=======================================================================================================================================
    else if (result == AppErrorState.unAuthorized) {
      ///use WidgetsBinding to schedule navigation after build is complete
      if (!_hasNavigated) {
        _hasNavigated = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && context.mounted) {
            AppRoutes.pushAndRemoveAllPageTo(context, const LoginScreen());
          }
        });
      }
      return const SizedBox();
    }

    ///on successful or pagination show data=============================================================================================================================================
    else if (result == AppFlowState.loaded ||
        result == AppFlowState.loadingMore) {
      if (widget.isDataEmpty()) {
        return widget.emptyBuilder();
      }
      return AppRefreshIndicator(
        onRefresh: widget.onReload,
        child: widget.successBuilder(widget.dataHandle.data as T),
      );
    }

    ///on error show retry button=============================================================================================================================================
    if (widget.isSmallError) {
      // Small error display - doesn't take full height
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: DecoratedBox(
          decoration: AppDecoration.decoration(
              shadow: false, showBorder: true, color: AppColor.lightRed),
          child: ListTile(
            title: AppText(
              text: AppErrorMessage.getMessage(result),
              fontWeight: FontWeight.bold,
              align: TextAlign.center,
              fontSize: AppSize.smallText,
            ),
            trailing: AppButtons(
              text: AppMessage.tryAgain,
              height: AppSize.inputFieldHeight,
              onPressed: () async {
                await widget.onReload();
              },
            ),
          ),
        ),
      );
    }

    // Full error display
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
              onPressed: () async {
                await widget.onReload();
              },
            ),
          ],
        ),
      ),
    );
  }
}
