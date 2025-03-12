import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class VerticalImageText extends StatelessWidget {
  const VerticalImageText({
    super.key,
    required this.image,
    this.backgroundColor = AppColors.white,
    this.onTap,
    required this.title,
  });
  final String image;
  final Color backgroundColor;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(right: AppSizes.spaceBtwItems.w),
          child: Column(
            children: [
              Container(
                width: 56.w,
                height: 56.h,
                padding: EdgeInsets.all(AppSizes.sm.w),
                decoration: BoxDecoration(
                  color: backgroundColor ??
                      (AppHelperFunctions.isDarkMode(context)
                          ? AppColors.black
                          : AppColors.white),
                  shape: BoxShape.circle
                ),
                child: Center(
                  child: Image(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                    color: AppHelperFunctions.isDarkMode(context)
                        ? AppColors.light
                        : AppColors.dark,
                  ),
                ),
              ),
              SizedBox(
                width: 55.w,
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: AppColors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ));
  }
}
