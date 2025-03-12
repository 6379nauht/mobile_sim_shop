import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/styles/shadow_style.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/core/widgets/icons/circular_icon.dart';
import 'package:mobile_sim_shop/core/widgets/images/rounded_image.dart';
import 'package:mobile_sim_shop/core/widgets/text/brand_title_text_icon.dart';
import 'package:mobile_sim_shop/core/widgets/text/product_title_text.dart';

class ProductCardVertical extends StatelessWidget {
  const ProductCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180.w,
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
            boxShadow: [ShadowStyle.verticalProductShadow],
            borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
            color: AppHelperFunctions.isDarkMode(context)
                ? AppColors.darkerGrey
                : AppColors.white),
        child: Column(
          children: [
            ///Thumbnail, Wishlist, Discount
            RoundedContainer(
              height: 180.h,
              padding: EdgeInsets.zero,
              backgroundColor: AppHelperFunctions.isDarkMode(context)
                  ? AppColors.dark
                  : AppColors.light,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ///Thumbnail image
                  // Sử dụng Positioned.fill để ảnh phủ kín toàn bộ container
                  const Positioned.fill(
                    child: RoundedImage(
                      imageUrl: AppImages.iphone13prm,
                      applyImageRadius: true,
                      fit: BoxFit.cover, // Đảm bảo ảnh lấp đầy và cắt xén phù hợp
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
                      ))
                ],
              ),
            ),
            SizedBox(
              height: (AppSizes.spaceBtwItems / 2).h,
            ),

            ///Details
            Padding(
              padding: EdgeInsets.only(left: AppSizes.sm.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProductTitleText(
                    title: 'Iphone 13 promax',
                    smallSizes: true,
                  ),
                  SizedBox(
                    height: (AppSizes.spaceBtwItems / 2).h,
                  ),
                  const BrandTitleTextIcon(title: 'Apple'),

                  SizedBox(height: AppSizes.spaceBtwItems.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Price
                      Expanded(
                        child: Text(
                          '12.000.000 VND',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16.sp),
                        ),
                      ),
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
          ],
        ),
      ),
    );
  }
}
