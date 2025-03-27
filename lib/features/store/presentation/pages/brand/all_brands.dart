import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/router/app_router.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/layouts/grid_layout.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/brand/brand_card.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/utils/constants/sizes.dart';

class AllBrandsPage extends StatelessWidget {
  const AllBrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: Text('Brand'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: Column(
            children: [
              const SectionHeading(
                title: 'Thương hiệu hàng đầu',
                showActionButton: false,
              ),
              SizedBox(
                height: AppSizes.spaceBtwItems.h,
              ),
              BlocBuilder<ProductBloc, ProductState>(builder: (_, state) {
                if (state.status == ProductStatus.loading) {
                  return const Center(child: CircularProgressIndicator(),);
                } else if (state.status == ProductStatus.failure) {
                  return Center(child: Text('Lỗi: ${state.errorMessage}'),);
                } else if (state.status == ProductStatus.success) {
                  return GridLayout(
                    itemCount: state.brands.length,
                    mainAxisExtent: 80,
                    itemBuilder: (_, index) => AppBrandCard(
                      showBorder: true,
                      brand: state.brands[index],
                      onTap: () => context.pushNamed(Routes.brandProductsName, extra: state.brands[index]),
                    ),
                  );
                } return const Center(child: Text('Lỗi không xác định!!'),);
              })
            ],
          ),
        ),
      ),
    );
  }
}
