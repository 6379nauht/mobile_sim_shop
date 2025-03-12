
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/helper_functions.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../custom_shapes/containers/rounded_container.dart';
import 'brand_cart.dart';

class BrandShowCase extends StatelessWidget {
  const BrandShowCase({
    super.key, required this.images,
  });
  final List<String> images;
  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      showBorder: true,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.all(AppSizes.md.r),
      borderColor: AppColors.darkerGrey,
      margin: EdgeInsets.only(bottom: AppSizes.spaceBtwItems.w),
      child: Column(
        children: [
          ///Brand  with Product
          const BrandCart(
            showBorder: false,
          ),

          ///Brand 3 product Image
          Row(
            children: images.map((image) => brandTopProductImageWidget(image, context)).toList(),
          )
        ],
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, context) {
    return Expanded(
        child: RoundedContainer(
          height: 100.h,
          backgroundColor: AppHelperFunctions.isDarkMode(context)
              ? AppColors.darkerGrey
              : AppColors.light,
          margin: EdgeInsets.only(right: AppSizes.sm.w),
          padding: EdgeInsets.all(AppSizes.md.r),
          child: Image(
            image: AssetImage(image),
            fit: BoxFit.contain,
          ),
        ));
  }
}