import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/core/widgets/text/product_title_text.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/core/widgets/chips/choice_chip.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_variation_model.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_state.dart';

class ProductAttributes extends StatelessWidget {
  final ProductModel product;

  const ProductAttributes({super.key, required this.product});

  ProductVariationModel? _findVariation(List<ProductVariationModel> variations, Map<String, String> selectedAttributes) {
    if (selectedAttributes.isEmpty || variations.isEmpty) return null;
    try {
      return variations.firstWhere(
            (variation) => selectedAttributes.entries.every(
              (entry) => variation.attributeValues[entry.key] == entry.value,
        ),
        orElse: () => ProductVariationModel.empty(),
      );
    } catch (e) {
      return null;
    }
  }

  Set<String> _getAttributeKeys(List<ProductVariationModel> variations) {
    final attributeKeys = <String>{};
    for (var variation in variations) {
      attributeKeys.addAll(variation.attributeValues.keys);
    }
    return attributeKeys;
  }

  Set<String> _getAvailableValues(List<ProductVariationModel> variations, String attributeName, Map<String, String> selectedAttributes) {
    return variations
        .where((variation) => selectedAttributes.entries
        .where((entry) => entry.key != attributeName)
        .every((entry) => variation.attributeValues[entry.key] == entry.value))
        .map((v) => v.attributeValues[attributeName])
        .where((value) => value != null)
        .cast<String>()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final variations = state.productVariation ?? [];
        final selectedVariation = _findVariation(variations, state.selectedVariations);

        if (state.status == ProductStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ProductStatus.failure) {
          return Center(child: Text(state.errorMessage ?? 'Lỗi tải variations'));
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedVariation != null && selectedVariation.id.isNotEmpty) ...[
              RoundedContainer(
                backgroundColor: dark ? AppColors.darkerGrey : AppColors.grey,
                padding: EdgeInsets.all(AppSizes.md.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SectionHeading(title: 'Variation', showActionButton: false),
                    SizedBox(height: AppSizes.spaceBtwItems.h / 2),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.sm.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const ProductTitleText(title: 'Giá bán: ', smallSizes: true),
                              Flexible(
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: AppSizes.xs.w,
                                  children: [
                                    Text(
                                      '${selectedVariation.price.toStringAsFixed(0)} VND',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleSmall!.apply(
                                        decoration: selectedVariation.salePrice > 0 && selectedVariation.salePrice != selectedVariation.price
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                    if (selectedVariation.salePrice > 0 && selectedVariation.salePrice != selectedVariation.price)
                                      Text(
                                        '${selectedVariation.salePrice.toStringAsFixed(0)} VND',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.spaceBtwItems.h / 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const ProductTitleText(title: 'Tình trạng: ', smallSizes: true),
                              Flexible(
                                child: Text(
                                  selectedVariation.stock > 0 ? 'Còn hàng' : 'Hết hàng',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: AppSizes.spaceBtwItems.h),
            if (variations.isNotEmpty)
              ..._getAttributeKeys(variations).map((attributeName) {
                final availableValues = _getAvailableValues(variations, attributeName, state.selectedVariations);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeading(title: attributeName),
                    SizedBox(height: AppSizes.spaceBtwItems.h / 2),
                    Wrap(
                      spacing: 8.w,
                      children: availableValues.map((value) => AppChoiceChip(
                        text: value,
                        selected: state.selectedVariations[attributeName] == value,
                        onSelected: (selected) {
                          context.read<ProductBloc>().add(
                            SelectVariation(
                              attributeName: attributeName,
                              value: selected ? value : null,
                            ),
                          );
                        },
                      )).toList(),
                    ),
                    SizedBox(height: AppSizes.spaceBtwItems.h),
                  ],
                );
              }),
          ],
        );
      },
    );
  }
}