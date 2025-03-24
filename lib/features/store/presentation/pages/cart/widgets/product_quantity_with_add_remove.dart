
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../core/helpers/helper_functions.dart';
import '../../../../../../core/utils/constants/colors.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import '../../../../../../core/widgets/icons/circular_icon.dart';

class ProductQuantityWithAddRemove extends StatelessWidget {
  const ProductQuantityWithAddRemove({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularIcon(
            icon: Iconsax.minus,
            backgroundColor: AppHelperFunctions.isDarkMode(context)
                ? AppColors.darkerGrey
                : AppColors.light,
            width: 32.w,
            height: 32.h,
            iconSize: AppSizes.md,
            iconColor: AppColors.white),
        SizedBox(
          width: AppSizes.spaceBtwItems.w,
        ),
        Text(
          '1',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(
          width: AppSizes.spaceBtwItems.w,
        ),
        CircularIcon(
            icon: Iconsax.add,
            backgroundColor: AppColors.primary,
            width: 32.w,
            height: 32.h,
            iconSize: AppSizes.md,
            iconColor: AppColors.white),
      ],
    );
  }
}
