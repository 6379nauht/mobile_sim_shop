
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/router/app_router.dart';
import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';

import '../../helpers/helper_functions.dart';
import '../../router/routes.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/enums.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../images/circular_image.dart';
import '../text/brand_title_text_icon.dart';

class BrandCart extends StatelessWidget {
  final BrandModel brand;
  final bool showBorder;
  const BrandCart({
    super.key, required this.showBorder, required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(Routes.brandProductsName, extra: brand),
      child: RoundedContainer(
        padding: EdgeInsets.all(AppSizes.sm.w),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          children: [
            ///Icon
            SizedBox(
              width: 40, // Fixed width for the icon
              child: CircularImage(
                image: brand.image,
                isNetworkImage: true,
                backgroundColor: Colors.transparent,
                overlayColor:
                AppHelperFunctions.isDarkMode(
                    context)
                    ? AppColors.white
                    : AppColors.black,
              ),
            ),
            SizedBox(
              width: AppSizes.spaceBtwItems.w / 2,
            ),

            ///Text
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BrandTitleTextIcon(
                    title: brand.name,
                    brandSizes: TextSizes.large,
                  ),
                  Text(
                    '${brand.productsCount} sản phẩm',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
