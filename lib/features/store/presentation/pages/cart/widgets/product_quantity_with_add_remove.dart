import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/icons/circular_icon.dart';
import 'package:mobile_sim_shop/features/store/data/models/cart_item_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/remove_cart_item.dart';
import 'package:mobile_sim_shop/features/store/data/models/update_quantity_params.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_event.dart';

class ProductQuantityWithAddRemove extends StatefulWidget {
  final CartItemModel cartItem;
  const ProductQuantityWithAddRemove({super.key, required this.cartItem});

  @override
  State<ProductQuantityWithAddRemove> createState() => _ProductQuantityWithAddRemoveState();
}

class _ProductQuantityWithAddRemoveState extends State<ProductQuantityWithAddRemove> {
  @override
  Widget build(BuildContext context) {
    // Quyết định màu icon dựa trên quantity
    final bool isQuantityGreaterThanOne = widget.cartItem.quantity > 1;
    final Color minusBackgroundColor = isQuantityGreaterThanOne
        ? AppColors.primary
        : (AppHelperFunctions.isDarkMode(context) ? AppColors.darkerGrey : AppColors.light);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularIcon(
          icon: Iconsax.minus,
          backgroundColor: minusBackgroundColor,
          width: 32.w,
          height: 32.h,
          iconSize: AppSizes.md,
          iconColor: AppColors.white,
          onPressed: () async {
            if (widget.cartItem.quantity > 1) {
              context.read<CartBloc>().add(
                UpdateProductQuantity(
                  params: UpdateQuantityParams(
                    productId: widget.cartItem.productId,
                    quantity: widget.cartItem.quantity - 1,
                  ),
                  variationId: widget.cartItem.variationId
                ),
              );
            } else if (widget.cartItem.quantity <= 1) {
              // Sử dụng hàm dùng chung để hiển thị dialog
              final confirmed = await AppHelperFunctions.showConfirmationDialog(
                context: context,
                title: 'Xác nhận xóa',
                content:
                'Bạn có chắc chắn muốn xóa "${widget.cartItem.title}" khỏi giỏ hàng không?',
                confirmText: 'Xóa',
                cancelText: 'Hủy',
              );

              if (confirmed) {
                context.read<CartBloc>().add(
                  RemoveCartItem(
                    params: RemoveCartItemParams(
                      productId: widget.cartItem.productId,
                      variationId: widget.cartItem.variationId,
                    ),
                  ),
                );
              }
            }
          },
        ),
        SizedBox(width: AppSizes.spaceBtwItems.w),
        Text(
          widget.cartItem.quantity.toString(), // Sửa thành widget.cartItem
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(width: AppSizes.spaceBtwItems.w),
        CircularIcon(
          icon: Iconsax.add,
          backgroundColor: AppColors.primary,
          width: 32.w,
          height: 32.h,
          iconSize: AppSizes.md,
          iconColor: AppColors.white,
          onPressed: () {
            if (widget.cartItem.quantity < widget.cartItem.stock) {
              context.read<CartBloc>().add(
                UpdateProductQuantity(
                  params: UpdateQuantityParams(
                    productId: widget.cartItem.productId,
                    quantity: widget.cartItem.quantity + 1,
                  ),
                  variationId: widget.cartItem.variationId
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                    Text('Số lượng vượt quá tồn kho (${widget.cartItem.stock})')),
              );
            }
          },
        ),
      ],
    );
  }
}