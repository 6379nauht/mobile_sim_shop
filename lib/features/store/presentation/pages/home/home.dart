import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/search_container.dart';
import 'package:mobile_sim_shop/core/widgets/layouts/grid_layout.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/carousel_indicator.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/carousel_slider.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/categories.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/home_appbar.dart';

import '../../../../../core/widgets/products/product_cards/product_card_vertical.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            AppPrimaryHeaderContainer(
              child: Column(
                children: [
                  const HomeAppBar(),
                  SizedBox(height: AppSizes.spaceBtwSections.h),
                  const SearchContainer(text: 'Tìm kiếm trong store'),
                  SizedBox(height: AppSizes.spaceBtwSections.h),
                  const Categories(),
                  SizedBox(
                    height: AppSizes.spaceBtwSections.h,
                  ),
                ],
              ),
            ),

            /// Body
            Padding(
              padding: EdgeInsets.all(AppSizes.defaultSpace.w),
              child: Column(
                children: [
                  /// Banner
                  const CarouselSliderWidget(
                      banners: [AppImages.banner1, AppImages.banner2]),
                  SizedBox(height: AppSizes.spaceBtwItems.h),
                  const CarouselIndicatorWidget(
                      banners: [AppImages.banner1, AppImages.banner2]),
                  SizedBox(height: AppSizes.spaceBtwSections.h),

                  SectionHeading(title: 'Sản phẩm phổ biến', onPressed: () {},),
                  SizedBox(height: AppSizes.spaceBtwItems.h),
                  ///Product
                  GridLayout(
                      itemCount: 5,
                      itemBuilder: (_, index) => const ProductCardVertical())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildUpdatedSimCard(String number, String price) {
  return Card(
    child: ListTile(
      title: Text(number),
      subtitle: Text(price),
    ),
  );
}
