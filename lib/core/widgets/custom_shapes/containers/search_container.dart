

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key, required this.text, this.icon = Iconsax.search_normal, this.showBackground = true, this.showBorder = true, this.padding,
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.md.w),
        decoration: BoxDecoration(
            color: showBackground ? dark ? AppColors.dark : AppColors.light : Colors.transparent,
            borderRadius:
            BorderRadius.circular(AppSizes.cardRadiusLg.r),
            border:showBorder ? Border.all(color: AppColors.grey) : null),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.darkerGrey,
            ),
            SizedBox(
              width: AppSizes.spaceBtwItems.w,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}