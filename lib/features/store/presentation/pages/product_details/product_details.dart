import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
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
    return Scaffold(
      bottomNavigationBar: const BottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 1- Product imlider
            ProductImageSlider(image: product.images ?? [],),

            /// 2 - Product Details
            Padding(
              padding: EdgeInsets.only(
                  right: AppSizes.defaultSpace.w,
                  left: AppSizes.defaultSpace.w,
                  bottom: AppSizes.defaultSpace.h),
              child: Column(
                children: [
                  /// - Rating & share button
                  const RatingAndShare(),

                  /// Price, title, stock and brand
                  ProductMetaData(product: product,),

                  ///Attributes
                  ProductAttributes(product: product,),
                  SizedBox(
                    height: AppSizes.spaceBtwSections.h,
                  ),

                  ///Checkout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {}, child: const Text('Mua ngay')),
                  ),
                  SizedBox(
                    height: AppSizes.spaceBtwSections.h,
                  ),

                  ///Description
                  const SectionHeading(
                    title: 'Mô tả',
                    showActionButton: false,
                  ),
                  SizedBox(
                    height: AppSizes.spaceBtwItems.h,
                  ),
                  ReadMoreText(
                      'iPhone 13 Pro Max sở hữu thiết kế sang trọng với khung thép không gỉ và mặt kính cường lực Ceramic Shield, mang đến độ bền cao. Máy được trang bị màn hình Super Retina XDR OLED 6.7 inch với tần số quét 120Hz ProMotion, cho trải nghiệm mượt mà và hình ảnh sắc nét. Hiệu năng mạnh mẽ nhờ chip Apple A15 Bionic cùng GPU 5 nhân, giúp xử lý mượt mà mọi tác vụ từ chơi game đến chỉnh sửa video.',
                  trimLength: 3,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '  Xem thêm',
                    trimExpandedText: '  Thu gọn',
                    moreStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    lessStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),

                  ///Reviews
                  const Divider(),
                  SizedBox(height: AppSizes.spaceBtwItems.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max, // Đảm bảo Row sử dụng đủ không gian ngang
                    children: [
                      const Expanded( // Bọc SectionHeading trong Expanded
                        child: SectionHeading(
                          title: 'Đánh giá (199)',
                          showActionButton: false,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.arrow_right_3, size: 18.sp),
                        constraints: const BoxConstraints.tightFor(), // Giảm không gian của IconButton
                      )
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
