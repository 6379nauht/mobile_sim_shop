import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/core/widgets/images/rounded_image.dart';
import 'package:mobile_sim_shop/core/widgets/text/brand_title_text_icon.dart';
import 'package:mobile_sim_shop/core/widgets/text/product_title_text.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';

import '../../../../features/store/data/models/brand_model.dart';
import '../../../../features/store/presentation/blocs/product/product_bloc.dart';
import '../../../../features/store/presentation/blocs/product/product_state.dart';
import '../../../../features/store/presentation/blocs/wishlist/wishlist_bloc.dart';
import '../../../../features/store/presentation/blocs/wishlist/wishlist_event.dart';
import '../../../../features/store/presentation/blocs/wishlist/wishlist_state.dart';
import '../../../helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/validators/validation.dart';
import '../../icons/circular_icon.dart';

class ProductCardHorizontal extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  const ProductCardHorizontal({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 310.w,
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
            color: AppHelperFunctions.isDarkMode(context)
                ? AppColors.darkerGrey
                : AppColors.softGrey),
        child: Row(
          children: [
            RoundedContainer(
              height: 120.h,
              padding: EdgeInsets.all(AppSizes.sm.r),
              backgroundColor: AppHelperFunctions.isDarkMode(context)
                  ? AppColors.dark
                  : AppColors.light,
              child: Stack(
                ///Thumbnail
                children: [
                  SizedBox(
                    height: 120.h,
                    width: 120.w,
                    child: RoundedImage(
                      imageUrl: product.thumbnail,
                      isNetworkImage: true,
                      applyImageRadius: true,
                    ),
                  ),
                  Positioned(
                    top: 12.w,
                    child: RoundedContainer(
                      radius: AppSizes.sm.r,
                      backgroundColor: AppColors.secondary.withOpacity(0.8),
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.sm.w, vertical: AppSizes.xs.h),
                      child: Text(
                        '${((product.price - product.salePrice) / product.price * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .apply(color: AppColors.black),
                      ),
                    ),
                  ),

                  ///Favourite Icon Button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: BlocBuilder<WishlistBloc, WishlistState>(
                      builder: (context, state) {
                        final isInWishlist = state.wishlist.contains(product.id);
                        final isLoading = state.status == WishlistStatus.loading;
                        return CircularIcon(
                          icon: isLoading
                              ? Iconsax.activity // Biểu tượng loading
                              : isInWishlist
                              ? Iconsax.heart5
                              : Iconsax.heart,
                          iconColor: isInWishlist ? Colors.red : null,
                          onPressed: isLoading
                              ? null // Vô hiệu hóa khi đang tải
                              : () {
                            if (isInWishlist) {
                              context.read<WishlistBloc>().add(RemoveFromWishlist(product.id));
                            } else {
                              context.read<WishlistBloc>().add(AddToWishlist(product.id));
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 172.w,
              child: Padding(padding: EdgeInsets.only(top: AppSizes.sm.h, left: AppSizes.sm.w),
                child: Column(
                  children: [
                    ProductTitleText(
                      title: product.title,
                      smallSizes: true,
                      maxLines: 2, // Limit title lines
                    ),
                    if (product.brand != null)
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          // Tìm brand trong danh sách brands dựa trên brandId
                          final brand = state.brands.firstWhere(
                                (b) => b.id == product.brand!.id,
                            orElse: () => BrandModel(id: '', name: 'Unknown', image: ''), // Giá trị mặc định nếu không tìm thấy
                          );
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: BrandTitleTextIcon(title: brand.name),
                          );
                        },
                      ),
                    const Spacer(), // Push the price row to the bottom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (product.salePrice > 0 &&
                                  product.salePrice != product.price)
                                Text(
                                  AppValidator.formatPrice(product.price),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Text(
                                product.salePrice > 0 &&
                                    product.salePrice != product.price
                                    ? AppValidator.formatPrice(product.salePrice)
                                    : AppValidator.formatPrice(product.price),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.dark,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppSizes.cardRadiusMd.r),
                              bottomRight:
                              Radius.circular(AppSizes.productImageRadius.r),
                            ),
                          ),
                          child: SizedBox(
                            width: AppSizes.iconLg.w * 1.2,
                            height: AppSizes.iconLg.h * 1.2,
                            child: const Center(
                              child: Icon(
                                Iconsax.add,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
