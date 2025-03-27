import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';

import '../../../../../core/widgets/images/rounded_image.dart';

class SubCategoriesPage extends StatelessWidget {
  final CategoryModel category;
  const SubCategoriesPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text(category.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: Column(
            ///Banner
            children: [
              RoundedImage(
                imageUrl: category.image,
                width: double.infinity,
                applyImageRadius: true,
                isNetworkImage: true,
              ),
              SizedBox(
                height: AppSizes.spaceBtwSections.h,
              ),

              ///Sub_category
              Column(
                children: [
                  SectionHeading(title: 'Apple', showActionButton: false,),
                  SizedBox(
                    height: AppSizes.spaceBtwItems.h / 2,
                  ),
                  SizedBox(
                    height: 120.h,
                    child: ListView.separated(
                      separatorBuilder: (_, __) => SizedBox(
                        width: AppSizes.spaceBtwItems.w,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (_, index) => const ProductCardHorizontal(),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
