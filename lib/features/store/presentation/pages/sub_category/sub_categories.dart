import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';

import '../../../../../core/widgets/images/rounded_image.dart';

class SubCategoriesPage extends StatelessWidget {
  const SubCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: Text('Điện Thoại'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: Column(
            ///Banner
            children: [
              const RoundedImage(
                imageUrl: AppImages.banner1,
                width: double.infinity,
                applyImageRadius: true,
              ),
              SizedBox(
                height: AppSizes.spaceBtwSections.h,
              ),

              ///Sub_category
              Column(
                children: [
                  const SectionHeading(title: 'Apple', showActionButton: false,),
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
