import 'package:flutter/material.dart';
import 'package:jayeek_vendor/core/constants/app_flow_sate.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/extensions/context_extensions.dart';
import '../model/data_handel.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/handle_unauthorized.dart';
import 'app_error_message.dart';
import 'app_error_state.dart';

class HandelPostRequest {
  static Future<void> handlePostRequest({
    required BuildContext context,
    required GlobalKey<FormState>? formKey,
    required Future<PostDataHandle> Function() request,
    required void Function(PostDataHandle data) onSuccess,
    void Function(PostDataHandle data)? onFailure,
  }) async {
    context.unfocused;
    if (formKey != null) {
      if (!formKey.currentState!.validate()) return;
    }

    final result = await request();

    if (!result.hasError) {
      onSuccess(result);
    } else {
      if (result.message == AppErrorState.unAuthorized) {
        handleUnauthorized();
      }

      if (onFailure != null) onFailure(result);
      if (context.mounted) {
        AppSnackBar.show(
          message:
              AppErrorMessage.getMessage(result.message ?? AppMessage.done),
          type: ToastType.error,
        );
      }
    }
  }
}
