import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/icons/circular_icon.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_variation_model.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_state.dart';

import '../../../blocs/product/product_event.dart';

class BottomAddToCart extends StatefulWidget {
  final ProductModel product;

  const BottomAddToCart({super.key, required this.product});

  @override
  State<BottomAddToCart> createState() => _BottomAddToCartState();
}

class _BottomAddToCartState extends State<BottomAddToCart> {
  int quantity = 1;
  bool _isAddingToCart = false;
  @override
  void initState() {
    super.initState();
    // Reset selectedVariations khi khởi tạo lần đầu
    context.read<ProductBloc>().add(ResetSelectedVariations());
  }
  @override
  void didUpdateWidget(BottomAddToCart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset selectedVariations khi widget được rebuild (người dùng quay lại màn hình)
    if (oldWidget.product.id != widget.product.id) {
      context.read<ProductBloc>().add(ResetSelectedVariations());
      setState(() {
        quantity = 1; // Reset quantity nếu cần
      });
    }
  }
  ProductVariationModel? _getSelectedVariation(List<ProductVariationModel> variations, Map<String, String> selectedVariations) {
    if (variations.isEmpty) {
      return null;
    }

    // Lấy danh sách các thuộc tính bắt buộc từ variation đầu tiên
    final requiredAttributes = variations.first.attributeValues.keys.toSet();

    // Kiểm tra xem selectedVariations có đủ số lượng thuộc tính bắt buộc không
    if (selectedVariations.length != requiredAttributes.length || !requiredAttributes.every((attr) => selectedVariations.containsKey(attr))) {
      return null; // Trả về null nếu thiếu thuộc tính
    }

    try {
      return variations.firstWhere(
            (variation) => variation.attributeValues.entries.every(
              (entry) => selectedVariations[entry.key] == entry.value,
        ),
        orElse: () => ProductVariationModel.empty(),
      );
    } catch (e) {
      return null;
    }
  }
  void _handleAddToCart(BuildContext context, Map<String, String> selectedVariations, List<ProductVariationModel> variations) {
    final selectedVariation = _getSelectedVariation(variations, selectedVariations);
    print('HandleAddToCart called');
    print('Selected Variations: $selectedVariations');
    print('Selected Variation: ${selectedVariation?.id ?? "null"}');
    print('Variations Count: ${variations.length}');

    if (variations.isNotEmpty) {
      if (selectedVariation == null || selectedVariation.id.isEmpty) {
        print('Showing SnackBar');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn đầy đủ biến thể hợp lệ')),
        );
        return;
      }
    }

    setState(() {
      _isAddingToCart = true;
    });

    context.read<CartBloc>().add(
      AddProductToCart(
        product: widget.product,
        selectedVariations: selectedVariations,
        quantity: quantity,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (_isAddingToCart) {
          if (state.status == CartStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã thêm vào giỏ hàng')),
            );
            setState(() {
              _isAddingToCart = false;
            });
          } else if (state.status == CartStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Có lỗi xảy ra')),
            );
            setState(() {
              _isAddingToCart = false;
            });
          }
        }
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, productState) {
          final selectedVariations = productState.selectedVariations;
          final variations = productState.productVariation ?? [];

          return Container(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace.w, vertical: AppSizes.defaultSpace.h / 2),
            decoration: BoxDecoration(
              color: AppHelperFunctions.isDarkMode(context) ? AppColors.darkerGrey : AppColors.light,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.cardRadiusLg.r),
                topRight: Radius.circular(AppSizes.cardRadiusLg.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircularIcon(
                      icon: Iconsax.minus,
                      backgroundColor: AppColors.darkerGrey,
                      width: 40.w,
                      height: 40.h,
                      iconColor: AppColors.white,
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                    ),
                    SizedBox(width: AppSizes.spaceBtwItems.w),
                    Text(
                      quantity.toString(),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(width: AppSizes.spaceBtwItems.w),
                    CircularIcon(
                      icon: Iconsax.add,
                      backgroundColor: AppColors.darkerGrey,
                      width: 40.w,
                      height: 40.h,
                      iconColor: AppColors.white,
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _handleAddToCart(context, selectedVariations, variations),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(AppSizes.md.r),
                    backgroundColor: AppColors.black,
                    side: const BorderSide(color: AppColors.black),
                  ),
                  child: const Text('Thêm vào giỏ hàng'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}