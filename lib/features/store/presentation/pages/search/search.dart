import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/search_container.dart';
import 'package:mobile_sim_shop/core/widgets/products/cart/cart_menu_icon.dart';

import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/appbar/appbar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text('Tra số', style: Theme.of(context).textTheme.headlineMedium,),
        actions: [
          CartCounterIcon(onPressed: (){})
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.w),
          child: Column(
            children: [
              SizedBox(height: AppSizes.spaceBtwSections.h,),
              const SearchContainer(text: 'Tìm kiếm số', showBorder: true, showBackground: false, padding: EdgeInsets.zero,),

            ],
          ),
      ),
    );
  }
}
