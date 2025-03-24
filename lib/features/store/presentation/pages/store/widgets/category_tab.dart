import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';

import '../../../../../../core/utils/constants/image_strings.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import '../../../../../../core/widgets/brands/brand_show_case.dart';
import '../../../../../../core/widgets/layouts/grid_layout.dart';
import '../../../../../../core/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../../../core/widgets/text/section_heading.dart';

class CategoryTab extends StatelessWidget {
  final CategoryModel category;

  const CategoryTab({
    super.key,
    required this.category,
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
            crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho đồng bộ
            children: [
              /// Brand/Showcase cho danh mục
              const BrandShowCase(
                images: [
                  AppImages.iphone13prm,
                  AppImages.iphone13prm,
                  AppImages.iphone13prm
                ],
              ),
              SizedBox(height: AppSizes.spaceBtwItems.h),

              /// Products liên quan đến danh mục
              SectionHeading(
                title: 'Sản phẩm ${category.name}',
                onPressed: () {}, // Có thể dẫn đến trang chi tiết
              ),
              SizedBox(height: AppSizes.spaceBtwItems.h),

              GridLayout(
                itemCount: 4, // Số lượng tạm thời, thay bằng dữ liệu thực nếu có
                itemBuilder: (_, index) => const ProductCardVertical(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}