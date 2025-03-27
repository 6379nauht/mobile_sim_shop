import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_state.dart';
import '../../layouts/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class SortableProducts extends StatefulWidget {
  final CategoryModel? category; // Optional cho trường hợp dùng category
  final BrandModel? brand; // Optional cho trường hợp dùng brand

  const SortableProducts({
    super.key,
    this.category,
    this.brand,
  });

  @override
  State<SortableProducts> createState() => _SortableProductsState();
}

class _SortableProductsState extends State<SortableProducts> {
  String selectedSortOption = 'Name';

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  void _applyFilter() {
    String filterOption;
    if (widget.brand != null) {
      // Trường hợp dùng brand (BrandProducts)
      filterOption = 'All|${widget.brand!.id}|$selectedSortOption';
    } else if (widget.category != null) {
      // Trường hợp dùng category (AllProductsPage)
      filterOption = '${widget.category!.id}|All|$selectedSortOption';
    } else {
      // Trường hợp không truyền category hoặc brand (hiển thị tất cả sản phẩm)
      filterOption = 'All|All|$selectedSortOption';
    }
    context.read<ProductBloc>().add(FilterProducts(filterOption: filterOption));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown cho sắp xếp
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          value: selectedSortOption,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedSortOption = value;
                _applyFilter();
              });
            }
          },
          items: [
            'Name',
            'Higher Price',
            'Lower Price',
            'Sale',
            'Newest',
          ].map((option) => DropdownMenuItem(
            value: option,
            child: Text(option),
          )).toList(),
        ),
        SizedBox(height: AppSizes.spaceBtwSections.h),

        // Hiển thị sản phẩm
        BlocBuilder<ProductBloc, ProductState>(
          builder: (_, state) {
            if (state.status == ProductStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == ProductStatus.failure) {
              return Center(child: Text('Lỗi: ${state.errorMessage}'));
            } else if (state.status == ProductStatus.success) {
              return GridLayout(
                itemCount: state.filterProducts.length,
                itemBuilder: (_, index) => ProductCardVertical(
                  product: state.filterProducts[index],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}