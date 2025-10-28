import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/context_extensions.dart';
import '../core/error/error_hander_type.dart';
import '../core/routing/routes_names.dart';
import '../core/theme/app_them.dart';
import '../features/home/presentation/screens/home_page.dart';

GlobalKey<NavigatorState> myNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    ///initialize global error handling
    initGlobalErrorHandling();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp(
        navigatorKey: myNavigatorKey,
        // home: HomePage(),
        onGenerateRoute: onGenerateRoute,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        theme: AppThem().getAppThem(),
        builder: (context, child) {
          if (context.isIOS) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: child,
            );
          }
          return child!;
        },
      ),
    );
  }
}
