
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/helper_functions.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/enums.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../images/circular_image.dart';
import '../text/brand_title_text_icon.dart';

class BrandCart extends StatelessWidget {
  const BrandCart({
    super.key, required this.showBorder,
  });
final bool showBorder;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                image: AppImages.iconPhone,
                isNetworkImage: false,
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
                  const BrandTitleTextIcon(
                    title: 'Apple',
                    brandSizes: TextSizes.large,
                  ),
                  Text(
                    '256 sản phẩm',
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
