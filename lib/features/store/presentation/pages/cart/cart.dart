import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/utils/validators/validation.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_state.dart';
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
        actions: [
          TextButton(
              onPressed: () async {
                final confirmed = await AppHelperFunctions.showConfirmationDialog(
                  context: context,
                  title: 'Xác nhận xóa',
                  content:
                  'Bạn có chắc chắn muốn xóa giỏ hàng không?',
                  confirmText: 'Xóa',
                  cancelText: 'Hủy',
                );

                if(confirmed) {
                  context.read<CartBloc>().add(ClearCart());
                }
              },
              child: Text(
                'Xóa tất cả',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: AppColors.warning),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: const ListCartItems(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppSizes.defaultSpace.r),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final totalPrice = state.cartItems.fold<double>(
              0,
              (sum, item) => sum + (item.price * item.quantity),
            );
            return ElevatedButton(
              onPressed: state.cartItems.isEmpty
                  ? null
                  : () => context.pushNamed(Routes.checkoutName),
              child:
                  Text('Thanh toán: ${AppValidator.formatPrice(totalPrice)}'),
            );
          },
        ),
      ),
    );
  }
}
