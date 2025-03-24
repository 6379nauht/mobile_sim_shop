import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/core/widgets/images/rounded_image.dart';
import 'package:mobile_sim_shop/core/widgets/text/brand_title_text_icon.dart';
import 'package:mobile_sim_shop/core/widgets/text/product_title_text.dart';

import '../../../helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../icons/circular_icon.dart';

class ProductCardHorizontal extends StatelessWidget {
  const ProductCardHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310.w,
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
          color: AppHelperFunctions.isDarkMode(context)
              ? AppColors.darkerGrey
              : AppColors.softGrey),
      child: Row(
        children: [
          RoundedContainer(
            height: 120.h,
            padding: EdgeInsets.all(AppSizes.sm.r),
            backgroundColor: AppHelperFunctions.isDarkMode(context)
                ? AppColors.dark
                : AppColors.light,
            child: Stack(
              ///Thumbnail
              children: [
                SizedBox(
                  height: 120.h,
                  width: 120.w,
                  child: const RoundedImage(
                    imageUrl: AppImages.iphone13prm,
                    applyImageRadius: true,
                  ),
                ),
                Positioned(
                  top: 12.w,
                  child: RoundedContainer(
                    radius: AppSizes.sm.r,
                    backgroundColor: AppColors.secondary.withOpacity(0.8),
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.sm.w, vertical: AppSizes.xs.h),
                    child: Text(
                      '25%',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .apply(color: AppColors.black),
                    ),
                  ),
                ),

                ///Favourite Icon Button
                const Positioned(
                    top: 0,
                    right: 0,
                    child: CircularIcon(
                      icon: Iconsax.heart5,
                      iconColor: Colors.red,
                    )),
              ],
            ),
          ),

          SizedBox(
            width: 172.w,
            child: Padding(padding: EdgeInsets.only(top: AppSizes.sm.h, left: AppSizes.sm.w),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProductTitleText(title: 'Điện thoại iphone 13 promax', smallSizes: true,),
                    SizedBox(height: AppSizes.spaceBtwItems.h,),
                    const BrandTitleTextIcon(title: 'Apple'),
                  ],
                ),

                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Price
                    Expanded(
                      child: Text(
                          '12.000.000 VND',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                      ),
                    ),

                    ///Add to cart
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppSizes.cardRadiusMd.r),
                              bottomRight: Radius.circular(
                                  AppSizes.productImageRadius.r))),
                      child: SizedBox(
                        width: AppSizes.iconLg.w * 1.2,
                        height: AppSizes.iconLg.h * 1.2,
                        child: const Center(
                          child: Icon(
                            Iconsax.add,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            ),
          )
        ],
      ),
    );
  }
}
