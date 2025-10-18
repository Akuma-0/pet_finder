import 'package:flutter/material.dart';
import 'package:pet_finder/core/helpers/constants.dart';
import 'core/helpers/hive_helper.dart';
import 'core/routing/app_router.dart';
import 'pet_finder_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
