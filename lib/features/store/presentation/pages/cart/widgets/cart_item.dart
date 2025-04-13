import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/images/rounded_image.dart';
import 'package:mobile_sim_shop/core/widgets/text/brand_title_text_icon.dart';
import 'package:mobile_sim_shop/core/widgets/text/product_title_text.dart';
import 'package:mobile_sim_shop/features/store/data/models/cart_item_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/remove_cart_item.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_event.dart';

class CartItem extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItem({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoundedImage(
          imageUrl: cartItem.image,
          width: 60.w,
          isNetworkImage: true,
          height: 60.h,
          padding: EdgeInsets.all(AppSizes.sm.r),
          backgroundColor: AppHelperFunctions.isDarkMode(context)
              ? AppColors.darkerGrey
              : AppColors.light,
        ),
        SizedBox(width: AppSizes.defaultSpace.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrandTitleTextIcon(title: cartItem.brandName ?? ''),
              ProductTitleText(title: cartItem.title, maxLines: 1),
              if (cartItem.selectedVariation != null &&
                  cartItem.selectedVariation!.isNotEmpty)
                Text.rich(
                  TextSpan(
                    children: cartItem.selectedVariation!.entries
                        .map(
                          (entry) => [
                            TextSpan(
                              text: '${entry.key}: ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: '${entry.value} ',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        )
                        .expand((element) => element)
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async{
            final confirmed = await AppHelperFunctions.showConfirmationDialog(
              context: context,
              title: 'Xác nhận xóa',
              content:
              'Bạn có chắc chắn muốn xóa "${cartItem.title}" khỏi giỏ hàng không?',
              confirmText: 'Xóa',
              cancelText: 'Hủy',
            );

            if (confirmed) {
              context.read<CartBloc>().add(
                RemoveCartItem(
                  params: RemoveCartItemParams(
                    productId: cartItem.productId,
                    variationId: cartItem.variationId,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
