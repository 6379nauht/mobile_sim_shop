import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/router/app_router.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/search_container.dart';
import 'package:mobile_sim_shop/core/widgets/layouts/grid_layout.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/banner/banner_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/banner/banner_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/carousel_indicator.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/carousel_slider.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/categories.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/widgets/home_appbar.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/widgets/products/product_cards/product_card_vertical.dart';
import '../../blocs/product/product_bloc.dart';

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
                  BlocBuilder<BannerBloc, BannerState>(builder: (_, state) {
                    if (state.status == BannerStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.status == BannerStatus.failure) {
                      return Center(
                        child: Text('Lỗi: ${state.errorMessage}'),
                      );
                    } else if (state.status == BannerStatus.success) {
                      return Column(
                        children: [
                          CarouselSliderWidget(banners: state.banners),
                          SizedBox(height: AppSizes.spaceBtwItems.h),
                          CarouselIndicatorWidget(banners: state.banners),
                        ],
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
                  SizedBox(height: AppSizes.spaceBtwSections.h),

                  ///Product
                  BlocBuilder<ProductBloc, ProductState>(builder: (_, state) {
                    if (state.status == ProductStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.status == ProductStatus.failure) {
                      return Center(
                        child: Text('Lỗi: ${state.errorMessage}'),
                      );
                    } else if (state.status == ProductStatus.success) {
                      return Column(
                        children: [
                          SectionHeading(
                            title: 'Sản phẩm phổ biến',
                            onPressed: () =>
                                context.pushNamed(Routes.allProductsName),
                          ),
                          SizedBox(height: AppSizes.spaceBtwItems.h),
                          GridLayout(
                              itemCount: state.products.length,
                              itemBuilder: (_, index) => ProductCardVertical(
                                  product: state.products[index])),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  })
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
