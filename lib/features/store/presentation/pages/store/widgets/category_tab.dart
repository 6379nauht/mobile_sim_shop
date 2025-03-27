import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/router/app_router.dart';
import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_state.dart';
import '../../../../../../core/router/routes.dart';
import '../../../../../../core/utils/constants/image_strings.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import '../../../../../../core/widgets/brands/brand_show_case.dart';
import '../../../../../../core/widgets/layouts/grid_layout.dart';
import '../../../../../../core/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../../../core/widgets/text/section_heading.dart';
import '../../../blocs/product/product_bloc.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Brand Showcase với nhiều thương hiệu
              BlocBuilder<ProductBloc, ProductState>(
                builder: (_, state) {
                  if (state.status == ProductStatus.loading) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (state.status == ProductStatus.failure) {
                    return Center(child: Text('Lỗi: ${state.errorMessage}'));
                  } else if (state.status == ProductStatus.success) {
                    // Lọc sản phẩm theo danh mục
                    final categoryProducts = state.products
                        .where((product) => product.categoryId == category.id)
                        .toList();

                    // Lấy danh sách brandId từ các sản phẩm trong danh mục
                    final brandIds = categoryProducts
                        .map((product) => product.brand!.id)
                        .toSet()
                        .toList(); // Loại bỏ trùng lặp

                    // Lọc danh sách thương hiệu liên quan đến danh mục
                    final relatedBrands = state.brands
                        .where((brand) => brandIds.contains(brand.id))
                        .toList();

                    // Nếu không có thương hiệu, hiển thị một thương hiệu mặc định hoặc không hiển thị
                    if (relatedBrands.isEmpty && state.brands.isNotEmpty) {
                      return Container();// Thương hiệu mặc định
                    }

                    // Lấy tối đa 3 hình ảnh thumbnail từ sản phẩm
                    final images = categoryProducts
                        .take(3) // Giới hạn 3 hình ảnh
                        .map((product) => product.thumbnail.isNotEmpty
                        ? product.thumbnail
                        : AppImages.iphone13prm)
                        .toList();

                    // Hiển thị BrandShowCase cho từng thương hiệu liên quan
                    return Column(
                      children: relatedBrands
                          .map((brand) => Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.sm.h),
                        child: BrandShowCase(
                          images: images,
                          brand: brand,
                        ),
                      ))
                          .toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              SizedBox(height: AppSizes.spaceBtwItems.h),

              /// Products liên quan đến danh mục
              SectionHeading(
                title: 'Sản phẩm ${category.name}',
                onPressed: () => context.pushNamed(Routes.allProductsName, extra: category),
              ),
              SizedBox(height: AppSizes.spaceBtwItems.h),

              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state.status == ProductStatus.loading) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (state.status == ProductStatus.failure) {
                    return Center(child: Text('Lỗi: ${state.errorMessage}'));
                  } else if (state.status == ProductStatus.success) {
                    final categoryProducts = state.products
                        .where((product) => product.categoryId == category.id)
                        .toList();

                    if (categoryProducts.isEmpty) {
                      return const Text('Không có sản phẩm nào trong danh mục này');
                    }

                    return GridLayout(
                      itemCount: categoryProducts.length,
                      itemBuilder: (_, index) => ProductCardVertical(
                        product: categoryProducts[index],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}