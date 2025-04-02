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
import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';

class AppBrandCard extends StatelessWidget {
  const AppBrandCard(
      {super.key, required this.showBorder, this.onTap, required this.brand});
  final bool showBorder;
  final BrandModel brand;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.all(AppSizes.sm.r),
        child: Row(
          children: [
            Flexible(
                child: CircularImage(
              image: brand.image,
              isNetworkImage: true,
              backgroundColor: Colors.transparent,
              overlayColor: AppHelperFunctions.isDarkMode(context)
                  ? AppColors.white
                  : AppColors.black,
            )),
            SizedBox(
              width: AppSizes.spaceBtwItems.w / 2,
            ),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrandTitleTextIcon(
                  title: brand.name,
                  brandSizes: TextSizes.large,
                ),
                Text(
                  '${brand.productsCount} sản phẩm',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
