import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/utils/validators/validation.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/cart/widgets/cart_item.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/cart/widgets/product_quantity_with_add_remove.dart';

class ListCartItems extends StatelessWidget {
  const ListCartItems({
    super.key,
    this.showAddRemoveButton = true,
  });

  final bool showAddRemoveButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // Kiểm tra trạng thái của giỏ hàng
        if (state.status == CartStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == CartStatus.failure) {
          return Center(child: Text(state.errorMessage ?? 'Lỗi tải giỏ hàng'));
        } else if (state.cartItems.isEmpty) {
          return const Center(child: Text('Giỏ hàng trống'));
        }

        // Hiển thị danh sách các mục trong giỏ hàng
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => SizedBox(height: AppSizes.defaultSpace.h),
          itemCount: state.cartItems.length, // Sử dụng số lượng thực tế từ state
          itemBuilder: (_, index) {
            final cartItem = state.cartItems[index]; // Lấy từng cartItem
            return Column(
              children: [
                CartItem(cartItem: cartItem), // Truyền cartItem vào CartItem
                if (showAddRemoveButton) SizedBox(height: AppSizes.spaceBtwItems.h),
                if (showAddRemoveButton)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 70.w),
                          ProductQuantityWithAddRemove(cartItem: cartItem), // Truyền cartItem vào
                        ],
                      ),
                      SizedBox(width: AppSizes.spaceBtwItems.w,),
                      Expanded(
                        child: Text(
                          AppValidator.formatPrice((cartItem.price * cartItem.quantity)), // Giá của từng mục
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }
}