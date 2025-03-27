import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/styles/shadow_style.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/core/widgets/icons/circular_icon.dart';
import 'package:mobile_sim_shop/core/widgets/images/rounded_image.dart';
import 'package:mobile_sim_shop/core/widgets/text/brand_title_text_icon.dart';
import 'package:mobile_sim_shop/core/widgets/text/product_title_text.dart';
import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import '../../../../features/store/domain/entities/brand.dart';
import '../../../../features/store/presentation/blocs/product/product_bloc.dart';
import '../../../../features/store/presentation/blocs/product/product_event.dart';
import '../../../../features/store/presentation/blocs/product/product_state.dart';
import '../../../router/routes.dart';
import '../../../utils/validators/validation.dart';

class ProductCardVertical extends StatelessWidget {
  final ProductModel product;
  const ProductCardVertical({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => context.pushNamed(Routes.productDetailsName, extra: product),
      child: Container(
        width: 180.w,
        constraints: BoxConstraints(
          maxHeight: 280.h, // Set a fixed maximum height
        ),
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
          color: AppHelperFunctions.isDarkMode(context)
              ? AppColors.darkerGrey
              : AppColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Thumbnail, Wishlist, Discount
            RoundedContainer(
              height: 180.h,
              padding: EdgeInsets.zero,
              backgroundColor: AppHelperFunctions.isDarkMode(context)
                  ? AppColors.dark
                  : AppColors.light,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: RoundedImage(
                      imageUrl: product.thumbnail.isNotEmpty
                          ? product.thumbnail
                          : AppImages.iphone13prm,
                      applyImageRadius: true,
                      fit: BoxFit.cover,
                      isNetworkImage: true,
                    ),
                  ),
                  if (product.salePrice > 0 && product.salePrice != product.price)
                    Positioned(
                      top: 12.w,
                      child: RoundedContainer(
                        radius: AppSizes.sm.r,
                        backgroundColor: AppColors.secondary.withOpacity(0.8),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.sm.w,
                          vertical: AppSizes.xs.h,
                        ),
                        child: Text(
                          '${((product.price - product.salePrice) / product.price * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: AppColors.black),
                        ),
                      ),
                    ),
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: CircularIcon(
                      icon: Iconsax.heart5,
                      iconColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            /// Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.sm.w,
                  vertical: 4.h, // Reduced vertical padding
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

