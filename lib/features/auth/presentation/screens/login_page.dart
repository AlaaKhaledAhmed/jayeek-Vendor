import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/context_extensions.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/error/handel_post_response.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/util/validator.dart';
import '../../../../../core/widgets/app_buttons.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_fields.dart';
import '../../../../../core/widgets/app_dialog.dart';
import '../../../../../generated/assets.dart';
import '../../../../core/routing/app_routes_methods.dart';
import '../../../home/presentation/screens/home_page.dart';
import '../../providers/login/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final Image _backgroundImage;

  @override
  void initState() {
    super.initState();
    _backgroundImage = Image.asset(Assets.imagesSplash);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_backgroundImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: context.height,
        width: context.width,
        color: AppColor.mainColor,
        child: _buildBody(context: context),
      ),
    );
  }

  //==========================================================================================================
  Widget _buildBody({required BuildContext context}) {
    final notifier = ref.read(loginProvider.notifier);
    final state = ref.watch(loginProvider);
    return Column(
      children: [
        Expanded(child: Container()),
        Expanded(
            flex: 4,
            child: DecoratedBox(
                decoration: AppDecoration.decoration(
                  color: AppColor.white,
                  radius: 35,
                  radiusOnlyTop: true,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 15.w,
                    right: 15.w,
                    top: context.height * 0.10,
                  ),
                  child: Form(
                    key: notifier.formKey,
                    child: Column(
                      children: [
                        ///login text
                        AppText(
                          text: AppMessage.loginText,
                          fontWeight: AppThem().bold,
                          fontSize: AppSize.heading2,
                          color: AppColor.mainColor,
                        ),
                        SizedBox(height: 15.h),

                        ///phone text-field
                        AppTextFields(
                          hintText: AppMessage.phone,
                          validator: AppValidator.validatorPhone,
                          controller: notifier.phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          suffix: const Text('962+'),
                          ltr: true,
                        ),
                        SizedBox(height: 10.h),

                        ///password text-field
                        AppTextFields(
                          hintText: AppMessage.password,
                          validator: AppValidator.validatorEmpty,
                          controller: notifier.passwordController,
                          ltr: true,
                        ),
                        SizedBox(height: 10.h),

                        ///login button
                        AppButtons(
                          width: AppSize.screenWidth,
                          text: AppMessage.loginText,
                          showLoader: state.isLoading,
                          radius: 10.r,
                          onPressed: () {
                            ///handel result
                            HandelPostRequest.handlePostRequest(
                              context: context,
                              formKey: notifier.formKey,
                              request: notifier.login,
                              onSuccess: (data) {
                                // Check if branchId or organizationId is null
                                final responseData = data.data?['data'];
                                final branchId = responseData?['branchId'];
                                final organizationId =
                                    responseData?['organizationId'];

                                if (branchId == null ||
                                    organizationId == null) {
                                  // Show error dialog
                                  _showNoBranchAssignedDialog(context);
                                  return;
                                }

                                // If both are present, proceed to home page
                                AppRoutes.pushReplacementTo(
                                    context, const HomePage());
                              },
                            );
                          },
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 40.w, right: 40.w, bottom: context.bottom),
                          child: Transform.translate(
                            offset: Offset(-100.w, 0),
                            child: Image(
                              image: _backgroundImage.image,
                              //width: context.width * 0.5.spMin,
                              // color: AppColor.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )))
      ],
    );
  }

  void _showNoBranchAssignedDialog(BuildContext context) {
    AppDialog.showAlertDialog(
      context: context,
      title: AppMessage.noBranchAssigned,
      message: AppMessage.noBranchAssignedMessage,
      onConfirm: () {
        Navigator.of(context).pop();
      },
    );
  }
}
