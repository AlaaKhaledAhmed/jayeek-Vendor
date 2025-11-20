import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/context_extensions.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
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
  late final Image _splash;
  @override
  void initState() {
    super.initState();
    _splash = Image.asset(Assets.imagesSplashTr);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    final String? isLogin = await SharedPreferencesService.getToken();

    if (isLogin == null) {
      AppRoutes.pushReplacementTo(context, const LoginScreen(),noAnimation: true);
    } else {
      AppRoutes.pushReplacementTo(context, const HomePage(),noAnimation: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_splash.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppText(
            text: 'كل طلب جاييّك...',
            fontWeight: FontWeight.bold,
            fontSize: AppSize.heading1 + 10,
            align: TextAlign.center,
            color: AppColor.subtextColor,
          ),
          AppText(
            text: 'بإدارة أسهل وتجربة أذكى.',
            fontWeight: FontWeight.bold,
            fontSize: AppSize.bodyText + 2,
            align: TextAlign.center,
            color: AppColor.mainColor,
          ),
          SizedBox(
            height: 50.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: Image(
              image: _splash.image,
              //width: context.width * 0.5.spMin,
              // color: AppColor.white,
            ),
          ),
        ],
      ),
    );
  }
}
