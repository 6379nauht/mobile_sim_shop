import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/core/widgets/text/product_title_text.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';

import '../../../../../../core/widgets/chips/choice_chip.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    return Column(
      mainAxisSize: MainAxisSize.min, // Đảm bảo tính toán kích thước đúng
      children: [
        RoundedContainer(
          backgroundColor: dark ? AppColors.darkerGrey : AppColors.grey,
          padding: EdgeInsets.all(AppSizes.md.r), // Thêm padding cho container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Căn trái nội dung
            mainAxisSize: MainAxisSize.min, // Đảm bảo tính toán kích thước đúng
            children: [
              // Tiêu đề "Tùy chọn"
              const SectionHeading(title: 'Tùy chọn', showActionButton: false),
              SizedBox(
                  height: AppSizes.spaceBtwItems.h /
                      2), // Khoảng cách giữa tiêu đề và thông tin

              // Phần thông tin giá
              Padding(
                padding: EdgeInsets.only(left: AppSizes.sm.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // Đảm bảo tính toán kích thước đúng
                  children: [
                    // Dòng giá
                    Row(
                      children: [
                        const ProductTitleText(
                            title: 'Giá bán: ', smallSizes: true),
                        Flexible(
                          // Bọc Flexible để tránh tràn
                          child: Wrap(
                            // Sử dụng Wrap thay vì Row
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: AppSizes.xs.w,
                            children: [
                              // Giá gốc
                              Text(
                                '13.250.000 VND',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .apply(
                                      decoration: TextDecoration.lineThrough,
                                    ),
                              ),

                              // Giá khuyến mãi
                              Text(
                                '12.000.000 VND',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                        height: AppSizes.spaceBtwItems.h /
                            2), // Khoảng cách giữa dòng giá và tình trạng

                    // Dòng tình trạng
                    Row(
                      mainAxisSize:
                          MainAxisSize.min, // Đảm bảo tính toán kích thước đúng
                      children: [
                        const ProductTitleText(
                            title: 'Tình trạng: ', smallSizes: true),
                        Flexible(
                          // Bọc Flexible để tránh tràn
                          child: Text(
                            'Còn hàng',
                            style: Theme.of(context).textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: AppSizes.spaceBtwItems.h,
        ),

        ///Attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(title: 'Colors'),
            SizedBox(
              height: AppSizes.spaceBtwItems.h / 2,
            ),
            Wrap(
              spacing: 8.w,
              children: [
                AppChoiceChip(text: 'Green', selected: false, onSelected: (value) {},),
                AppChoiceChip(text: 'Blue', selected: true, onSelected: (value) {},),
                AppChoiceChip(text: 'Yellow', selected: false, onSelected: (value) {},),
              ],
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(title: 'Size'),
            SizedBox(
              height: AppSizes.spaceBtwItems.h / 2,
            ),
            Wrap(
              spacing: 8.w,
              children: [
                AppChoiceChip(text: '128GB', selected: true, onSelected: (value) {},),
                AppChoiceChip(text: '256GB', selected: true, onSelected: (value) {},),
                AppChoiceChip(text: '512GB', selected: false, onSelected: (value) {},),
              ],
            )
          ],
        ),
      ],
    );
  }
}

