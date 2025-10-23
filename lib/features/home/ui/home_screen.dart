import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_finder/features/home/ui/widgets/home_bloc_builder.dart';
import 'package:pet_finder/features/home/ui/widgets/search_box.dart';

import '../../../core/helpers/constants.dart';
import '../../../core/theme/text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Forever Pet', style: TextStyles.font24W700),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 16.w, top: 3.h),
            child: Icon(
              Icons.notifications_none_outlined,
              size: 28.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: scaffoldPadding,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            SearchBox(
              prefixIcon: Image.asset(
                'assets/images/search-normal.png',
                width: 20.w,
                height: 20.h,
              ),
              suffixIcon: RotatedBox(
                quarterTurns: 3,
                child: Icon(Icons.tune, size: 24.sp),
              ),
            ),
            SizedBox(height: 22.h),
            Expanded(child: HomeBlocBuilder()),
          ],
        ),
      ),
    );
  }
}
