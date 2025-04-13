import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace), required this.onTap,
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.md.w),
          decoration: BoxDecoration(
              color: showBackground
                  ? dark
                  ? AppColors.dark
                  : AppColors.light
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg.r),
              border: showBorder ? Border.all(color: AppColors.grey) : null),
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
      ),
    );
  }
}
