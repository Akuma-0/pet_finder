import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_finder/core/theme/colors_manager.dart';
import 'package:pet_finder/features/home/ui/widgets/breeds_list_view.dart';

import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';

class HomeBlocBuilder extends StatelessWidget {
  const HomeBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const Center(
            child: CircularProgressIndicator(color: ColorsManager.tealB6),
          ),
          success: (breedsList) {
            return setupSuccess(breedsList);
          },
          error: (errorHandler) => setupError(),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget setupSuccess(breedsList) {
    return BreedsListView(breeds: breedsList);
  }

  Widget setupError() {
    return Center(
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 20.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            'Failed to load breeds',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please check your internet connection',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
