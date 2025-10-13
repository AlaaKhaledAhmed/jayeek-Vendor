import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/context_extensions.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/routing/app_routes_methods.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../../generated/assets.dart';
import '../../../auth/presentation/screens/login_page.dart';
import '../../../home/presentation/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Image _backgroundImage;
  late final Image _logo;
  @override
  void initState() {
    super.initState();
    _backgroundImage = Image.asset(Assets.imagesBackground);
    _logo = Image.asset(Assets.imagesLogo);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    final String? isLogin = await SharedPreferencesService.getLogin();

    if (isLogin == null) {
      AppRoutes.pushReplacementTo(context, const LoginScreen());
    } else {
      AppRoutes.pushReplacementTo(context, const HomePage());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_backgroundImage.image, context);
    precacheImage(_logo.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppDecoration.decoration(
          color: AppColor.mainColor,
          image: _backgroundImage.image,
          alignment: AlignmentDirectional.bottomCenter,
          // cover: true
        ),
        alignment: Alignment.center,
        height: AppSize.screenHeight,
        width: AppSize.screenWidth,
        child: Image(image: _logo.image, width: context.width * 0.5.spMin,color: AppColor.white,),
      ),
    );
  }
}