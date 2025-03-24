import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/enums.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/core/widgets/images/circular_image.dart';
import 'package:mobile_sim_shop/core/widgets/text/brand_title_text_icon.dart';
import 'package:mobile_sim_shop/core/widgets/text/product_title_text.dart';

class ProductMetaData extends StatelessWidget {
  const ProductMetaData({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure the Column has a defined width constraint from its parent
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Add this to ensure proper size calculation
      children: [
        ///Price and Sale Price
        Wrap( // Replace Row with Wrap to handle overflow better
          spacing: AppSizes.spaceBtwItems.w,
          runSpacing: AppSizes.xs.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ///Sale tag
            RoundedContainer(
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

            ///Price
            Text(
              '13.250.000 VND',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall!.apply(
                decoration: TextDecoration.lineThrough,
              ),
            ),

            ///Sale Price
            Text(
              '12.000.000 VND',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Changed from labelLarge with custom size to standard titleLarge
            ),
          ],
        ),
        SizedBox(
          height: AppSizes.spaceBtwItems.h / 1.5,
        ),

        ///Title
        const ProductTitleText(title: 'Iphone 13 promax'),
        SizedBox(
          height: AppSizes.spaceBtwItems.h / 1.5,
        ),

        ///Stock status
        Row(
          mainAxisSize: MainAxisSize.min, // Add this to ensure proper size calculation
          children: [
            const ProductTitleText(title: 'Tình trạng: '), // Added colon for better readability
            const SizedBox(width: 4), // Small spacing between label and value
            Flexible( // Wrap in Flexible to handle potential overflow
              child: Text(
                'Còn hàng',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppSizes.spaceBtwItems.h / 1.5,
        ),

        ///Brand
        Row(
          mainAxisSize: MainAxisSize.min, // Add this to ensure proper size calculation
          children: [
            CircularImage(
              image: AppImages.iconPhone,
              width: 32.w,
              height: 32.h,
              overlayColor: AppHelperFunctions.isDarkMode(context)
                  ? AppColors.white
                  : AppColors.black,
            ),
            const SizedBox(width: 8), // Add spacing between image and text
            const Flexible( // Wrap in Flexible to handle potential overflow
              child: BrandTitleTextIcon(
                title: 'Apple',
                brandSizes: TextSizes.medium,
              ),
            ),
          ],
        )
      ],
    );
  }
}