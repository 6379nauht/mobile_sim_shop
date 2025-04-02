import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/store/widgets/category_tab.dart';

import '../../../../../core/helpers/helper_functions.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/appbar/app_tab_bar.dart';
import '../../../../../core/widgets/appbar/appbar.dart';
import '../../../../../core/widgets/brands/brand_cart.dart';
import '../../../../../core/widgets/custom_shapes/containers/search_container.dart';
import '../../../../../core/widgets/layouts/grid_layout.dart';
import '../../../../../core/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../core/widgets/text/section_heading.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../blocs/product/product_state.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController sẽ được cập nhật sau khi có danh sách danh mục
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (_, state) {
      if (state.status == CategoryStatus.loading) {
        return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
      } else if (state.status == CategoryStatus.failure) {
        return Scaffold(body: Center(child: Text(state.errorMessage ?? 'Lỗi tải danh mục')));
      }

      final categories = state.categories;
      // Khởi tạo TabController với số lượng tab dựa trên danh sách danh mục
      _tabController = TabController(length: categories.length, vsync: this);

      return BlocBuilder<ProductBloc, ProductState>(builder: (_, state) {
        return Scaffold(
          appBar: AppAppBar(
            title: Text('Store', style: Theme.of(context).textTheme.headlineMedium),
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
                        SizedBox(height: AppSizes.spaceBtwItems.h),
                        const SearchContainer(
                          text: 'Tìm kiếm trong Store',
                          showBorder: true,
                          showBackground: false,
                          padding: EdgeInsets.zero,
                        ),
                        SizedBox(height: AppSizes.spaceBtwItems.h),
                        SectionHeading(
                          title: 'Thương hiệu hàng đầu',
                          showActionButton: true,
                          onPressed: () => context.pushNamed(Routes.allBrandsName),
                        ),
                        SizedBox(height: AppSizes.spaceBtwItems.h / 2.5),
                        GridLayout(
                          itemCount: state.brands.length > 4 ? 4 : state.brands.length,
                          mainAxisExtent: 60,
                          itemBuilder: (_, index) {
                            return BrandCart(showBorder: true, brand: state.brands[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                  bottom: AppTabBar(
                    controller: _tabController, // Sử dụng TabController
                    tabs: categories.map((category) => Tab(child: Text(category.name))).toList(),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController, // Sử dụng TabController
              children: categories
                  .asMap()
                  .entries
                  .map((entry) => CategoryTab(
                category: entry.value,
                tabIndex: entry.key,
                tabController: _tabController, // Truyền TabController vào CategoryTab
              ))
                  .toList(),
            ),
          ),
        );
      });
    });
  }
}