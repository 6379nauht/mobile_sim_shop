
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../core/helpers/helper_functions.dart';
import '../../../../../../core/utils/constants/colors.dart';
import '../../../../../../core/utils/constants/image_strings.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import '../../../../../../core/widgets/appbar/appbar.dart';
import '../../../../../../core/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../../core/widgets/icons/circular_icon.dart';
import '../../../../../../core/widgets/images/rounded_image.dart';

class ProductImageSlider extends StatelessWidget {
  const ProductImageSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppCurvedEdgeWidget(
        child: Container(
          color: AppHelperFunctions.isDarkMode(context)
              ? AppColors.darkerGrey
              : AppColors.light,
          child: Stack(
            children: [
              ///Main large image
              SizedBox(
                height: 400.h,
                child: Padding(
                  padding:
                  EdgeInsets.all(AppSizes.productImageRadius.r * 2),
                  child: const Center(
                    child: Image(image: AssetImage(AppImages.iphone13prm)),
                  ),
                ),
              ),

              ///image slider
              Positioned(
                  right: 0,
                  bottom: 30,
                  left: AppSizes.defaultSpace.w,
                  child: SizedBox(
                    height: 80.h,
                    child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (_, index) => RoundedImage(
                          imageUrl: AppImages.iphone13prm,
                          width: 80.w,
                          backgroundColor:
                          AppHelperFunctions.isDarkMode(context)
                              ? AppColors.dark
                              : AppColors.white,
                          border: Border.all(color: AppColors.primary),
                          padding: EdgeInsets.all(AppSizes.sm.r),
                        ),
                        separatorBuilder: (_, __) => SizedBox(
                          width: AppSizes.defaultSpace.w,
                        ),
                        itemCount: 6),
                  )),

              ///AppBar Icons
              const AppAppBar(
                showBackArrow: true,
                actions: [
                  CircularIcon(icon: Iconsax.heart5, iconColor: Colors.red,)
                ],
              )
            ],
          ),
        ));
  }
}