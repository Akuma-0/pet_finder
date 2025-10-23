import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_finder/core/helpers/constants.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/hive_helper.dart';
import 'core/routing/app_router.dart';
import 'pet_finder_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await dotenv.load(fileName: ".env");
  await setupGetIt();
  await HiveHelper.initHive();
  await checkIsOnboardingSeen();
  runApp(PetFinderApp(appRouter: AppRouter()));
}

checkIsOnboardingSeen() async {
  final data = await HiveHelper.getDataFromBox(
    boxName: HiveConstants.sharedPrefsBox,
    key: HiveConstants.isOnboardingCompleted,
  );
  isOnboardingSeen = data ?? false;
}
