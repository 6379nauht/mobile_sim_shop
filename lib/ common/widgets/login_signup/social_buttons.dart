
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/constants/image_strings.dart';
import '../../../core/utils/constants/sizes.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(100.r)),
          child: IconButton(
            onPressed: () {},
            icon: Image(
              image: const AssetImage(AppImages.google),
              width: AppSizes.iconMd.w,
              height: AppSizes.iconMd.h,
            ),
          ),
        ),
        SizedBox(
          width: AppSizes.spaceBtwItems.w,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(100.r)),
          child: IconButton(
            onPressed: () {},
            icon: Image(
              image: const AssetImage(AppImages.facebook),
              width: AppSizes.iconMd.w,
              height: AppSizes.iconMd.h,
            ),
          ),
        )
      ],
    );
  }
}
