import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/helpers/constants.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theme/colors_manager.dart';

class PetFinderApp extends StatelessWidget {
  final AppRouter appRouter;
  const PetFinderApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Pet Finder',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.generateRoute,
        theme: ThemeData(
          primaryColor: ColorsManager.tealB6,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.black)),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
        initialRoute: isOnboardingSeen
            ? Routes.homeScreen
            : Routes.onBoardingScreen,
      ),
    );
  }
}
