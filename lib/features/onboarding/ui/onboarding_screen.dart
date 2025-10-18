import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_finder/core/helpers/extensions.dart';
import '../../../core/helpers/constants.dart';
import '../../../core/helpers/hive_helper.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/colors_manager.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/app_elevated_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: scaffoldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70.h),
            Image.asset('assets/images/onboarding_dog.png'),
            SizedBox(height: 50.h),
            Text(
              'Find Your Best Companion With Us',
              style: TextStyles.font32W700,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              'Join & discover the best suitable pets as per your preferences in your location',
              style: TextStyles.font16W400.copyWith(
                color: ColorsManager.grey9F,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60.h),
            AppElevatedButton(
              onPressed: () {
                HiveHelper.addDataToBox(
                  boxName: HiveConstants.sharedPrefsBox,
                  key: HiveConstants.isOnboardingCompleted,
                  value: true,
                );
                context.pushReplacementNamed(Routes.homeScreen);
              },
              buttonChild: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/clow.png'),
                  SizedBox(width: 12.w),
                  Text(
                    'Get Started',
                    style: TextStyles.font18W500.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
