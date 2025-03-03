import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class VerticalImageText extends StatelessWidget {
  const VerticalImageText({
    super.key,
    required this.image,
    this.backgroundColor = AppColors.white,
    this.onTap,
  });
  final String image;
  final Color backgroundColor;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: AppSizes.spaceBtwItems),
          child: Column(
            children: [
              Container(
                width: 84.w,
                height: 46.h,
                padding: EdgeInsets.all(AppSizes.sm.w),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(color: AppColors.accent, width: 1.w),
                    borderRadius: BorderRadius.circular(10.r)),
                child: Center(
                  child: Image(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
