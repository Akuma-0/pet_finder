import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_finder/core/theme/colors_manager.dart';
import 'package:pet_finder/core/theme/text_styles.dart';

import '../../data/models/breeds_response_model.dart';

class BreedTile extends StatelessWidget {
  const BreedTile({super.key, required this.breed});
  final Breed breed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1A000000), // #0000001A
              blurRadius: 4.0,
              offset: const Offset(0, 0),
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 112.w,
              height: 112.h,
              decoration: BoxDecoration(
                color: ColorsManager.tealF9,
                borderRadius: BorderRadiusGeometry.circular(8.r),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    'https://cdn2.thecatapi.com/images/${breed.referenceImageId ?? ''}.jpg',
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(
                  child: Image.asset('assets/images/picture_loading.gif'),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported,
                  color: ColorsManager.tealB6,
                  size: 40.sp,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    right: 0.w,
                    child: Icon(
                      Icons.favorite_border,
                      color: ColorsManager.tealB6,
                      size: 28.sp,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          breed.name ?? '',
                          style: TextStyles.font18W700,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: ColorsManager.tealB6,
                            size: 16.sp,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            breed.origin ?? '',
                            style: TextStyles.font14W400,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/weight_icon.png',
                            width: 16.w,
                            height: 16.h,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "${breed.weight?.metric ?? 'N/A'} kg",
                            style: TextStyles.font14W400,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(
                            Icons.elderly,
                            color: ColorsManager.red4a,
                            size: 16.sp,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "${breed.lifeSpan ?? ''} years",
                            style: TextStyles.font14W400,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
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
