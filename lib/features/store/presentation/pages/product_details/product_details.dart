import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/product_details/widgets/bottom_add_to_cart.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/product_details/widgets/product_attributes.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/product_details/widgets/product_image_slider.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/product_details/widgets/product_meta_data.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/product_details/widgets/rating_share.dart';
import 'package:readmore/readmore.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo FetchVariationsByProductId khi vào trang
    context.read<ProductBloc>().add(FetchVariationsByProductId(productId: product.id));

    return Scaffold(
      bottomNavigationBar: BottomAddToCart(product: product),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductImageSlider(image: product.images ?? [], product: product),
            Padding(
              padding: EdgeInsets.only(
                right: AppSizes.defaultSpace.w,
                left: AppSizes.defaultSpace.w,
                bottom: AppSizes.defaultSpace.h,
              ),
              child: Column(
                children: [
                  const RatingAndShare(),
                  ProductMetaData(product: product),
                  ProductAttributes(product: product),
                  SizedBox(height: AppSizes.spaceBtwSections.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Mua ngay'),
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections.h),
                  const SectionHeading(title: 'Mô tả', showActionButton: false),
                  SizedBox(height: AppSizes.spaceBtwItems.h),
                  ReadMoreText(
                    '${product.description}',
                    trimLength: 3,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '  Xem thêm',
                    trimExpandedText: '  Thu gọn',
                    moreStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    lessStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  const Divider(),
                  SizedBox(height: AppSizes.spaceBtwItems.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Expanded(
                        child: SectionHeading(title: 'Đánh giá (199)', showActionButton: false),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.arrow_right_3, size: 18.sp),
                        constraints: const BoxConstraints.tightFor(),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}