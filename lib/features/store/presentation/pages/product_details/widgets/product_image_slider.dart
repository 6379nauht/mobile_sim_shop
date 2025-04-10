import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:mobile_sim_shop/core/widgets/icons/circular_icon.dart';
import 'package:mobile_sim_shop/core/widgets/images/rounded_image.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';

import '../../../blocs/wishlist/wishlist_bloc.dart';
import '../../../blocs/wishlist/wishlist_event.dart';
import '../../../blocs/wishlist/wishlist_state.dart';

class ProductImageSlider extends StatefulWidget {
  final List<String> image;
  final ProductModel product;
  const ProductImageSlider({super.key, required this.image, required this.product});

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  int _selectedImageIndex = 0; // Chỉ số của ảnh lớn đang được hiển thị

  @override
  Widget build(BuildContext context) {
    return AppCurvedEdgeWidget(
      child: Container(
        color: AppHelperFunctions.isDarkMode(context)
            ? AppColors.darkerGrey
            : AppColors.light,
        child: Stack(
          children: [
            /// Main large image
            SizedBox(
              height: 400.h,
              child: Padding(
                padding: EdgeInsets.all(AppSizes.productImageRadius.r * 2),
                child: Center(
                  child: RoundedImage(
                    imageUrl: widget.image.isNotEmpty
                        ? widget.image[_selectedImageIndex]
                        : AppImages.iphone13prm,
                    fit: BoxFit.contain, // Điều chỉnh để ảnh lớn hiển thị đầy đủ
                    isNetworkImage: true, // Kiểm tra nếu là ảnh mạng
                  ),
                ),
              ),
            ),

            /// Image slider (ảnh nhỏ)
            Positioned(
              right: 0,
              bottom: 30,
              left: AppSizes.defaultSpace.w,
              child: SizedBox(
                height: 80.h,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = index; // Cập nhật ảnh lớn khi nhấp
                      });
                    },
                    child: RoundedImage(
                      imageUrl: widget.image.isNotEmpty
                          ? widget.image[index]
                          : AppImages.iphone13prm,
                      width: 80.w,
                      backgroundColor: AppHelperFunctions.isDarkMode(context)
                          ? AppColors.dark
                          : AppColors.white,
                      border: Border.all(
                        color: _selectedImageIndex == index
                            ? AppColors.primary // Đường viền nổi bật khi được chọn
                            : Colors.transparent,
                      ),
                      padding: EdgeInsets.all(AppSizes.sm.r),
                      isNetworkImage: widget.image.isNotEmpty,
                    ),
                  ),
                  separatorBuilder: (_, __) => SizedBox(
                    width: AppSizes.defaultSpace.w,
                  ),
                  itemCount: widget.image.isNotEmpty ? widget.image.length : 6,
                ),
              ),
            ),

            /// AppBar Icons
            AppAppBar(
              showBackArrow: true,
              actions: [
                BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, state) {
                    final isInWishlist = state.wishlist.contains(widget.product.id);
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
                          context.read<WishlistBloc>().add(RemoveFromWishlist(widget.product.id));
                        } else {
                          context.read<WishlistBloc>().add(AddToWishlist(widget.product.id));
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}