import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/icons/circular_icon.dart';

class BottomAddToCart extends StatelessWidget {
  const BottomAddToCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace.w, vertical: AppSizes.defaultSpace.h /2),
      decoration: BoxDecoration(
        color: AppHelperFunctions.isDarkMode(context) ? AppColors.darkerGrey : AppColors.light,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.cardRadiusLg.r),
          topRight: Radius.circular(AppSizes.cardRadiusLg.r)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircularIcon(icon: Iconsax.minus,
              backgroundColor: AppColors.darkerGrey,
                width: 40.w,
                height: 40.h,
                  iconColor: AppColors.white
              ),
              SizedBox(width: AppSizes.spaceBtwItems.w,),
              Text('1', style: Theme.of(context).textTheme.titleSmall,),
              SizedBox(width: AppSizes.spaceBtwItems.w,),

              CircularIcon(icon: Iconsax.add,
                  backgroundColor: AppColors.darkerGrey,
                  width: 40.w,
                  height: 40.h,
                  iconColor: AppColors.white
              ),
            ],
          ),
          ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(AppSizes.md.r),
            backgroundColor: AppColors.black,
            side: const BorderSide(color: AppColors.black),
          ),child: const Text('Thêm vào giỏ hàng'))
        ],
      ),
    );
  }
}
