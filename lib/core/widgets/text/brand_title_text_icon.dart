import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/utils/constants/enums.dart';
import 'package:mobile_sim_shop/core/widgets/text/brand_title_text.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class BrandTitleTextIcon extends StatelessWidget {
  const BrandTitleTextIcon(
      {super.key,
      required this.title,
      this.maxLines = 1,
      this.textColor,
      this.iconColor = AppColors.primary,
      this.textAlign = TextAlign.center,
      this.brandSizes = TextSizes.small});
  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes brandSizes;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       Flexible(
           child: BrandTitleText(title: title,

           color: textColor,
               maxLines: maxLines,
               textAlign: textAlign,
             brandTextSize: brandSizes),),

        SizedBox(width: AppSizes.xs.w,),
        const Icon(
          Iconsax.verify5,
          color: AppColors.primary,
          size: AppSizes.iconXs,
        )
      ],
    );
  }
}
