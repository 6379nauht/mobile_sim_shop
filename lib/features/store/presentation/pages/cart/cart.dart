import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/cart/widgets/list_cart_items.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        showBackArrow: true,
        title: Text(
          'Giỏ hàng',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: const ListCartItems(),
        ),
      ),

      ///checkout button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppSizes.defaultSpace.r),
        child: ElevatedButton(
            onPressed: () => context.pushNamed(Routes.checkoutName), child: const Text('Thanh toán: 12.444.333VND')),
      ),
    );
  }
}

