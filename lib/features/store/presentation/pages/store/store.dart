import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/app_tab_bar.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/search_container.dart';
import 'package:mobile_sim_shop/core/widgets/layouts/grid_layout.dart';
import 'package:mobile_sim_shop/core/widgets/products/cart/cart_menu_icon.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/core/widgets/brands/brand_cart.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/store/widgets/category_tab.dart';

import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (_, state) {
      if (state.status == CategoryStatus.loading) {
        return const Scaffold(
          body: Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      } else if (state.status == CategoryStatus.failure) {
        return Scaffold(
          body: Center(
            child: Text(state.errorMessage ?? 'Lỗi tải danh mục'),
          ),
        );
      }

      final categories = state.categories;
      return DefaultTabController(
        length: categories.length,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppAppBar(
            title: Text(
              'Store',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            actions: [CartCounterIcon(onPressed: () {})],
          ),
          body: NestedScrollView(
              headerSliverBuilder: (_, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      floating: true,
                      backgroundColor: AppHelperFunctions.isDarkMode(context)
                          ? AppColors.black
                          : AppColors.white,
                      expandedHeight: 440.h,
                      flexibleSpace: Padding(
                        padding: EdgeInsets.all(AppSizes.defaultSpace.w),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: AppSizes.spaceBtwItems.h,
                            ),

                            ///Search bar
                            const SearchContainer(
                              text: 'Tìm kiếm trong Store',
                              showBorder: true,
                              showBackground: false,
                              padding: EdgeInsets.zero,
                            ),
                            SizedBox(
                              height: AppSizes.spaceBtwItems.h,
                            ),

                            ///Feature Brands
                            SectionHeading(
                              title: 'Thương hiệu hàng đầu',
                              showActionButton: true,
                              onPressed: () {},
                            ),
                            SizedBox(
                              height: AppSizes.spaceBtwItems.h / 2.5,
                            ),

                            ///Grid brands
                            GridLayout(
                                itemCount: 4,
                                mainAxisExtent:
                                    60, // Increased from 40 to allow more space
                                itemBuilder: (_, index) {
                                  return const BrandCart(
                                    showBorder: true,
                                  );
                                }),
                          ],
                        ),
                      ),

                      ///Tab
                      bottom: AppTabBar(
                          tabs: categories
                              .map((category) => Tab(
                                    child: Text(category.name),
                                  ))
                              .toList()))
                ];
              },
              body: TabBarView(
                  children: categories
                      .map((category) => CategoryTab(
                            category: category,
                          ))
                      .toList())),
        ),
      );
    });
  }
}
