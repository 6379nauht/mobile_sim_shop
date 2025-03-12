
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constants/image_strings.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import '../../../../../../core/widgets/brands/brand_show_case.dart';
import '../../../../../../core/widgets/layouts/grid_layout.dart';
import '../../../../../../core/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../../../core/widgets/text/section_heading.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: Column(
            children: [
              ///Brand
              const BrandShowCase(images: [
                AppImages.iphone13prm,
                AppImages.iphone13prm,
                AppImages.iphone13prm
              ]),
              SizedBox(
                height: AppSizes.spaceBtwItems.h,
              ),

              ///Products
              SectionHeading(title: 'Gợi ý dành cho bạn', onPressed: () {}),
              SizedBox(
                height: AppSizes.spaceBtwItems.h,
              ),
              GridLayout(
                  itemCount: 4,
                  itemBuilder: (_, index) => const ProductCardVertical()),
            ],
          ),
        )
      ],
    );
  }
}
