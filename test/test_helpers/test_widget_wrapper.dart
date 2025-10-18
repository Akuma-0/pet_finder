import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_finder/core/routing/app_router.dart';
import 'package:pet_finder/core/theme/colors_manager.dart';

/// A wrapper widget for testing that provides the necessary context
/// for widgets that depend on MaterialApp, ScreenUtil, and theme
class TestWidgetWrapper extends StatelessWidget {
  final Widget child;
  final AppRouter? appRouter;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;

  const TestWidgetWrapper({
    super.key,
    required this.child,
    this.appRouter,
    this.onGenerateRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Pet Finder Test',
        debugShowCheckedModeBanner: false,
        onGenerateRoute:
            onGenerateRoute ?? (appRouter ?? AppRouter()).generateRoute,
        theme: ThemeData(
          primaryColor: ColorsManager.tealB6,
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
        ),
        home: child,
      ),
    );
  }
}

/// A simplified wrapper for basic widget testing without navigation
class SimpleTestWrapper extends StatelessWidget {
  final Widget child;

  const SimpleTestWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }
}
