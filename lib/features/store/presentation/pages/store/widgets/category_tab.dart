import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/router/routes.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import '../../../../../../core/widgets/brands/brand_show_case.dart';
import '../../../../../../core/widgets/layouts/grid_layout.dart';
import '../../../../../../core/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../../../core/widgets/text/section_heading.dart';
import '../../../../data/models/category_model.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/product/product_event.dart';
import '../../../blocs/product/product_state.dart';

class CategoryTab extends StatefulWidget {
  final CategoryModel category;
  final int tabIndex; // Chỉ số tab để xác định tab hiện tại
  final TabController tabController; // Nhận TabController từ parent

  const CategoryTab({
    super.key,
    required this.category,
    required this.tabIndex,
    required this.tabController,
  });

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> with AutomaticKeepAliveClientMixin {
  late ProductBloc _productBloc;

  @override
  void initState() {
    super.initState();
    _productBloc = context.read<ProductBloc>(); // Lấy ProductBloc ngay trong initState
    widget.tabController.addListener(_handleTabChange); // Lắng nghe thay đổi tab
    _fetchData(); // Tải dữ liệu lần đầu
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Không cần gọi _fetchData() ở đây vì đã xử lý trong initState và _handleTabChange
  }

  void _handleTabChange() {
    if (widget.tabController.index == widget.tabIndex && mounted) {
      _fetchData(); // Tải dữ liệu khi tab này được chọn
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange); // Xóa listener
    super.dispose();
  }

  void _reset() {
    _productBloc.add(ResetProductState());
  }

  void _fetchData() {
    print('Fetching data for Category ID: ${widget.category.id}');
    _productBloc.add(FetchProductByCategoryId(categoryId: widget.category.id));
  }

  @override
  bool get wantKeepAlive => true; // Giữ trạng thái của tab

  @override
  Widget build(BuildContext context) {
    super.build(context); // Yêu cầu bởi AutomaticKeepAliveClientMixin
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {},
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(AppSizes.defaultSpace.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (_, state) {
                    print('Trạng thái thương hiệu (Tab ${widget.tabIndex}): ${state.status}');
                    if (state.status == ProductStatus.loading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.status == ProductStatus.failure) {
                      return Center(child: Text('Lỗi: ${state.errorMessage}'));
                    } else if (state.status == ProductStatus.success) {
                      final relatedBrands = state.relatedBrands;
                      final images = state.thumbnailImages;
                      if (relatedBrands.isEmpty && state.brands.isNotEmpty) {
                        return Container();
                      }
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
                SectionHeading(
                  title: 'Sản phẩm ${widget.category.name}',
                  onPressed: () => context.pushNamed(
                    Routes.allProductsName,
                    extra: widget.category,
                  ),
                ),
                SizedBox(height: AppSizes.spaceBtwItems.h),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    print('Trạng thái sản phẩm (Tab ${widget.tabIndex}): ${state.status}');
                    print('Số sản phẩm (Tab ${widget.tabIndex}): ${state.categoryProducts.length}');
                    if (state.status == ProductStatus.loading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.status == ProductStatus.failure) {
                      return Center(child: Text('Lỗi: ${state.errorMessage}'));
                    } else if (state.status == ProductStatus.success) {
                      final categoryProducts = state.categoryProducts;
                      if (categoryProducts.isEmpty) {
                        return Center(
                          child: Text(
                            'Không có sản phẩm nào trong danh mục ${widget.category.name}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
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
      ),
    );
  }
}