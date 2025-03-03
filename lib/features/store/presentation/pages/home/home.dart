import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/search_container.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/carousel_indicator.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/carousel_slider.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/categories.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/home_appbar.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/search_day_year.dart';

import '../../../../../core/widgets/button/price_button.dart';

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
                  const SearchContainer(text: 'Tìm kiếm số'),
                  SizedBox(height: AppSizes.spaceBtwSections.h),
                  const Categories(),
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

                  ///Search
                  const SectionHeading(
                    title: 'Tìm Sim Ngày Sinh - Năm Sinh',
                    showActionButton: false,
                    textColor: AppColors.black,
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections.h),

                  /// Search for SIM by birth date & year
                  const SearchDayYear(),
                  SizedBox(height: AppSizes.spaceBtwItems.h),

                  ///Select by price
                  const SectionHeading(
                    title: 'Chọn Theo Giá',
                    showActionButton: false,
                    textColor: AppColors.black,
                  ),
                  SizedBox(height: AppSizes.spaceBtwItems.h),

                  GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    shrinkWrap: true,  // Sửa lỗi
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.5, // Tắt cuộn riêng của GridView
                    children: const [
                      PriceButton(label: '< 500,000'),
                      PriceButton(label: '500 - 1 triệu'),
                      PriceButton(label: '1 - 5 triệu'),
                      PriceButton(label: '5 - 10 triệu'),
                      PriceButton(label: '10 - 50 triệu'),
                      PriceButton(label: '50 - 100 triệu'),
                      PriceButton(label: '> 100 triệu'),
                    ],
                  ),

                  SizedBox(height: AppSizes.spaceBtwItems.h),

                  ///Select by price
                  const SectionHeading(
                    title: 'Sim Vừa Cập Nhật',
                    showActionButton: false,
                    textColor: AppColors.black,
                  ),
                  SizedBox(height: AppSizes.spaceBtwItems.h),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // List for updated sim numbers
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            buildUpdatedSimCard('0974628686', '26.000.000đ'),
                            buildUpdatedSimCard('0399.177.178', '2.000.000đ'),
                            buildUpdatedSimCard('0973.981.282', '1.500.000đ'),
                            buildUpdatedSimCard('0366.77.87.97', '2.000.000đ'),
                            buildUpdatedSimCard('0965.299.297', '1.500.000đ'),
                          ],
                        ),
                      ],
                    ),
                  ),
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
