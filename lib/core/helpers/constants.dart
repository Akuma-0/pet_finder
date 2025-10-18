import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final scaffoldPadding = EdgeInsets.symmetric(horizontal: 15.w);
bool isOnboardingSeen = false;

class HiveConstants {
  static const String sharedPrefsBox = "sharedPreferencesBox";
  static const String isOnboardingCompleted = 'isOnboardingCompleted';
}
