import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/icons/circular_icon.dart';
import 'package:mobile_sim_shop/core/widgets/layouts/grid_layout.dart';
import 'package:mobile_sim_shop/core/widgets/products/product_cards/product_card_vertical.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/wishlist/wishlist_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/wishlist/wishlist_state.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          CircularIcon(
            icon: Iconsax.add,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, wishlistState) {
              if (wishlistState.status == WishlistStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (wishlistState.status == WishlistStatus.failure) {
                return Center(child: Text('Error: ${wishlistState.errorMessage}'));
              } else if (wishlistState.status == WishlistStatus.success) {
                if (wishlistState.wishlist.isEmpty) {
                  return const Center(child: Text('Your wishlist is empty'));
                }
                return BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, productState) {
                    // Filter products based on wishlist IDs
                    final wishlistProducts = productState.products
                        .where((product) => wishlistState.wishlist.contains(product.id))
                        .toList();

                    return GridLayout(
                      itemCount: wishlistProducts.length,
                      itemBuilder: (_, index) => ProductCardVertical(
                        product: wishlistProducts[index],
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}