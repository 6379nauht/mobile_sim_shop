import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/enums.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/utils/validators/validation.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/core/widgets/images/circular_image.dart';
import 'package:mobile_sim_shop/core/widgets/text/brand_title_text_icon.dart';
import 'package:mobile_sim_shop/core/widgets/text/product_title_text.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_event.dart';

import '../../../../data/models/brand_model.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/product/product_state.dart';

class ProductMetaData extends StatelessWidget {
  final ProductModel product;
  const ProductMetaData({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Make sure the Column has a defined width constraint from its parent
    if (product.brand?.id != null) {
      context.read<ProductBloc>().add(FetchBrandById(brandId: product.brand!.id));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Add this to ensure proper size calculation
      children: [
        ///Price and Sale Price
        Wrap( // Replace Row with Wrap to handle overflow better
          spacing: AppSizes.spaceBtwItems.w,
          runSpacing: AppSizes.xs.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            /// Sale tag
            if (product.salePrice > 0 && product.salePrice != product.price)
              RoundedContainer(
                radius: AppSizes.sm.r,
                backgroundColor: AppColors.secondary.withOpacity(0.8),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.sm.w,
                  vertical: AppSizes.xs.h,
                ),
                child: Text(
                  '${((product.price - product.salePrice) / product.price * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelLarge!.apply(color: AppColors.black),
                ),
              ),

            /// Price
            Text(
              AppValidator.formatPrice(product.price),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall!.apply(
                decoration: product.salePrice > 0 && product.salePrice != product.price
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            
            /// Sale Price
            if (product.salePrice > 0 && product.salePrice != product.price)
              Text(
                AppValidator.formatPrice(product.salePrice),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
          ],
        ),
        SizedBox(
          height: AppSizes.spaceBtwItems.h / 1.5,
        ),

        ///Title
        ProductTitleText(title: product.title),
        SizedBox(
          height: AppSizes.spaceBtwItems.h / 1.5,
        ),

        /// Stock status
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ProductTitleText(title: 'Tình trạng: '),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                product.stock > 0 ? 'Còn hàng' : 'Hết hàng',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppSizes.spaceBtwItems.h / 1.5,
        ),

        /// Brand
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            final brand = state.brand;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularImage(
                  image: brand?.image ?? 'https://i.imgur.com/lbkxvtE.png',
                  width: 32.w,
                  height: 32.h,
                  overlayColor: AppHelperFunctions.isDarkMode(context)
                      ? AppColors.white
                      : AppColors.black,
                  isNetworkImage: true,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: BrandTitleTextIcon(
                    title: brand?.name ?? 'Unknown',
                    brandSizes: TextSizes.medium,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}