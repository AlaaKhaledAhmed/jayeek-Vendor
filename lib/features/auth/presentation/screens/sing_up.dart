import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/context_extensions.dart';
import 'package:jayeek_vendor/features/auth/presentation/screens/login_page.dart';
import 'package:jayeek_vendor/features/auth/providers/sing_up/sing_up_provider.dart';
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
import '../../../../../generated/assets.dart';
import '../../../../core/routing/app_routes_methods.dart';
import '../../../home/presentation/screens/home_page.dart';

class SingUp extends ConsumerStatefulWidget {
  const SingUp({super.key});

  @override
  ConsumerState<SingUp> createState() => _SingUpState();
}

class _SingUpState extends ConsumerState<SingUp> {
  late final Image _backgroundImage;

  @override
  void initState() {
    super.initState();
    _backgroundImage = Image.asset(Assets.imagesBackground);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_backgroundImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.height,
        width: context.width,
        decoration: AppDecoration.decoration(
          color: AppColor.mainColor,
          radius: 0,
          image: _backgroundImage.image,
          alignment: AlignmentDirectional.bottomCenter,
        ),
        child: _buildBody(context: context),
      ),
    );
  }

  //==========================================================================================================
  Widget _buildBody({required BuildContext context}) {
    final notifier = ref.read(singUpProvider.notifier);
    return Padding(
      padding: EdgeInsets.only(
        left: AppSize.horizontalPadding,
        right: AppSize.horizontalPadding,
        top: 25.h,
      ),
      child: Form(
        key: notifier.formKey,
        child: Column(
          spacing: 10.h,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///sing-up text
            AppText(
              text: AppMessage.singUpText,
              fontWeight: AppThem().bold,
              fontSize: AppSize.heading2,
              color: AppColor.white,
            ),
            SizedBox(height: 15.h),

            ///name text-field
            AppTextFields(
              hintText: AppMessage.name,
              validator: AppValidator.validatorEmpty,
              controller: notifier.nameController,
            ),

            ///supervisor text-field
            AppTextFields(
              hintText: AppMessage.supervisor,
              validator: AppValidator.validatorEmpty,
              controller: notifier.supervisorController,
            ),

            ///email text-field
            AppTextFields(
              hintText: AppMessage.email,
              validator: AppValidator.validatorEmpty,
              controller: notifier.emailController,
              ltr: true,
            ),

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

            ///password text-field
            AppTextFields(
              hintText: AppMessage.password,
              validator: AppValidator.validatorEmpty,
              controller: notifier.passwordController,
              ltr: true,
            ),

            ///login button
            AppButtons(
              width: AppSize.screenWidth,
              text: AppMessage.singUpText,
              //showLoader: state.isLoading,
              radius: 10.r,
              onPressed: () {
                ///handel result
                HandelPostRequest.handlePostRequest(
                  context: context,
                  formKey: notifier.formKey,
                  request: notifier.singUp,
                  onSuccess: (data) {
                    AppRoutes.pushReplacementTo(context, const HomePage());
                  },
                );
              },
            ),
            const SizedBox(),

            ///login text
            InkWell(
              onTap: () {
                AppRoutes.pushReplacementTo(context, const LoginScreen());
              },
              child: AppText(
                text: AppMessage.haveAccount,
                fontWeight: AppThem().bold,
                fontSize: AppSize.smallText,
                color: AppColor.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
