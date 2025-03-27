import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/brands/brand_cart.dart';
import 'package:mobile_sim_shop/core/widgets/products/sortable_products/sortable_products.dart';
import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';

import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';

class BrandProducts extends StatelessWidget {
  final BrandModel brand;
  const BrandProducts({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text(brand.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: Column(
            children: [
              BrandCart(showBorder: true, brand: brand),
              SizedBox(height: AppSizes.spaceBtwSections.h),
              SortableProducts(brand: brand), // Truyền brand vào đây
            ],
          ),
        ),
      ),
    );
  }
}