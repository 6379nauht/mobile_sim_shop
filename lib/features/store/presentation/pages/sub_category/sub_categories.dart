import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_event.dart';
import 'package:mobile_sim_shop/core/widgets/images/rounded_image.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/widgets/products/product_cards/product_card_horizontal.dart';
import '../../blocs/product/product_state.dart';
// Trong SubCategoriesPage
class SubCategoriesPage extends StatefulWidget {
  final CategoryModel category;
  const SubCategoriesPage({super.key, required this.category});

  @override
  State<SubCategoriesPage> createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    if (widget.category.parentId == null) {
      context
          .read<CategoryBloc>()
          .add(FetchSubcategories(parentId: widget.category.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text(widget.category.name),
        showBackArrow: true,
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state.status == CategoryStatus.success) {
            // Chỉ fetch sản phẩm cho các subcategory hiện tại
            for (var subCategory in state.subCategories) {
              context
                  .read<ProductBloc>()
                  .add(FetchProductByCategoryId(categoryId: subCategory.id));
            }
          }
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (_, categoryState) {
            if (categoryState.status == CategoryStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (categoryState.status == CategoryStatus.failure) {
              return Center(child: Text('Lỗi: ${categoryState.errorMessage}'));
            } else if (categoryState.status == CategoryStatus.success) {
              final subCategories = categoryState.subCategories;

              if (subCategories.isEmpty) {
                return const Center(child: Text('Không có danh mục con'));
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.defaultSpace.r),
                  child: Column(
                    children: [
                      // Ảnh đại diện
                      RoundedImage(
                        imageUrl: subCategories.first.image.isNotEmpty
                            ? subCategories.first.image
                            : AppImages.iphone13prm,
                        width: double.infinity,
                        applyImageRadius: true,
                        isNetworkImage: true,
                      ),
                      SizedBox(height: AppSizes.spaceBtwSections.h),

                      // Danh sách sản phẩm theo subcategory
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, productState) {
                          return Column(
                            children: subCategories.map((subCategory) {
                              // Lọc sản phẩm an toàn
                              final products = productState.products
                                  .where((product) =>
                              product.categoryId == subCategory.id)
                                  .toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Tiêu đề subcategory
                                  SectionHeading(
                                    title: subCategory.name,
                                    showActionButton: false,
                                  ),
                                  SizedBox(height: AppSizes.spaceBtwItems.h / 2),

                                  // Danh sách sản phẩm
                                  SizedBox(
                                    height: 120.h,
                                    child: products.isEmpty
                                        ? Center(
                                        child: Text(
                                          'Chưa có sản phẩm trong ${subCategory.name}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ))
                                        : ListView.separated(
                                      separatorBuilder: (_, __) =>
                                          SizedBox(
                                              width: AppSizes
                                                  .spaceBtwItems.w),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: products.length,
                                      itemBuilder: (_, index) =>
                                          ProductCardHorizontal(
                                            product: products[index],
                                            onTap: () => context.pushNamed(
                                                Routes.productDetailsName,
                                                extra: products[index]),
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: AppSizes.spaceBtwSections.h),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}