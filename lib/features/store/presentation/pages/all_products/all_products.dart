import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';
import '../../../../../core/widgets/products/sortable_products/sortable_products.dart';

class AllProductsPage extends StatelessWidget {
  final CategoryModel? category;

  const AllProductsPage({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text(category != null ? 'Sản phẩm phổ biến - ${category!.name}' : 'Tất cả sản phẩm'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: SortableProducts(category: category), // Truyền category hoặc null
        ),
      ),
    );
  }
}