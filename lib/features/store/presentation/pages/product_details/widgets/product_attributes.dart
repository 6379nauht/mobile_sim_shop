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

class ProductAttributes extends StatefulWidget {
  final ProductModel product;

  const ProductAttributes({super.key, required this.product});

  @override
  State<ProductAttributes> createState() => _ProductAttributesState();
}

class _ProductAttributesState extends State<ProductAttributes> {
  final Map<String, String> _selectedAttributes = {};
  ProductVariationModel? _selectedVariation;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchVariationsByProductId(productId: widget.product.id));
  }

  ProductVariationModel? _findVariation(List<ProductVariationModel> variations) {
    if (_selectedAttributes.isEmpty || variations.isEmpty) return null;
    try {
      return variations.firstWhere(
            (variation) => _selectedAttributes.entries.every(
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

  // Lấy các giá trị khả dụng cho một thuộc tính dựa trên các lựa chọn trước đó
  Set<String> _getAvailableValues(
      List<ProductVariationModel> variations, String attributeName) {
    return variations
        .where((variation) => _selectedAttributes.entries
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
        _selectedVariation = _findVariation(variations);

        if (state.status == ProductStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ProductStatus.failure) {
          return Center(child: Text(state.errorMessage ?? 'Lỗi tải variations'));
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
        if (_selectedVariation != null && _selectedVariation!.id.isNotEmpty) ...[
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
                                      '${_selectedVariation!.price.toStringAsFixed(0)} VND',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleSmall!.apply(
                                        decoration: _selectedVariation!.salePrice > 0 &&
                                            _selectedVariation!.salePrice != _selectedVariation!.price
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                    if (_selectedVariation!.salePrice > 0 &&
                                        _selectedVariation!.salePrice != _selectedVariation!.price)
                                      Text(
                                        '${_selectedVariation!.salePrice.toStringAsFixed(0)} VND',
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
                                  _selectedVariation!.stock > 0 ? 'Còn hàng' : 'Hết hàng',
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

            /// Hiển thị thuộc tính động với giá trị khả dụng
            if (variations.isNotEmpty)
              ..._getAttributeKeys(variations).map((attributeName) {
                final availableValues = _getAvailableValues(variations, attributeName);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeading(title: attributeName),
                    SizedBox(height: AppSizes.spaceBtwItems.h / 2),
                    Wrap(
                      spacing: 8.w,
                      children: availableValues.map((value) => AppChoiceChip(
                        text: value,
                        selected: _selectedAttributes[attributeName] == value,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedAttributes[attributeName] = value;
                            } else {
                              _selectedAttributes.remove(attributeName);
                            }
                          });
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