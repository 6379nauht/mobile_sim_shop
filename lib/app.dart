import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/network/network_bloc.dart';
import 'package:mobile_sim_shop/core/router/app_router.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/check_email_verification_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/save_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signin_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signin_with_google_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signout_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signup_usecase.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/password_configuration/password_configuration_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signup/signup_bloc.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/delete_account_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/fetch_adddresss_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/remove_address_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/save_address_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/update_address_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/update_user_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_bloc.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_event.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile/profile_bloc.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/add_to_cart_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/clear_cart_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_all_brands_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_all_products_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_brand_by_id_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_payment_method_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_product_by_category_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_product_by_id_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_subcategories_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_suggestions_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_variation_by_product_id_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_variation_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/filter_products_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_all_banners_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_all_categories_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_cart_item_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_variation_id_attributes_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_wishlist_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/remove_cart_item_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/remove_wishlist_item_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/save_wishlist_item_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/search_product_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/send_order_confirmation_email_usecase.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/banner/banner_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/banner/banner_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/carousel_slider/carousel_slider_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/search/search_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/wishlist/wishlist_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/wishlist/wishlist_event.dart';

import 'core/utils/theme/app_theme.dart';
import 'features/auth/presentation/blocs/signin/signin_event.dart';
import 'features/personalization/presentation/blocs/profile/profile_event.dart';
import 'features/store/domain/usecases/create_invoice_usecase.dart';
import 'features/store/domain/usecases/create_payment_intent_usecase.dart';
import 'features/store/domain/usecases/select_payment_method_usecase.dart';
import 'features/store/domain/usecases/update_quantity_usecase.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo ScreenUtil trong builder của MaterialApp với BuildContext
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return MultiBlocProvider(
      providers: [
        ///Network
        BlocProvider<NetworkBloc>(
          create: (_) => NetworkBloc(),
        ),

        ///Signup
        BlocProvider<SignupBloc>(
            create: (_) => SignupBloc(
                getIt<SignupUseCase>(),
                getIt<DeleteUserUsecase>(),
                getIt<CheckEmailVerifiedUsecase>())),

        ///Signin
        BlocProvider<SigninBloc>(
            create: (_) => SigninBloc(
                getIt<GetRememberMeUseCase>(),
                getIt<SaveRememberMeUseCase>(),
                getIt<SigninUsecase>(),
                getIt<GetCurrentUserUsecase>(),
                getIt<SignOutUsecase>(),
                getIt<SignInWithGoogleUsecase>())
              ..add(LoadRememberMe())
              ..add(CheckStatusSignIn())),

        ///ResetPassword
        BlocProvider<PasswordConfigurationBloc>(
          create: (_) => PasswordConfigurationBloc(
            getIt<ResetPasswordUsecase>(),
          ),
        ),

        ///Carousel
        BlocProvider<CarouselBloc>(
          create: (_) => CarouselBloc(),
        ),

        ///Profile
        BlocProvider<ProfileBloc>(
            create: (_) => ProfileBloc(
                  getIt<GetCurrentUserUsecase>(),
                  getIt<UpdateUserUsecase>(),
                  getIt<DeleteAccountUsecase>(),
                )..add(LoadProfile())),

        ///Category
        BlocProvider<CategoryBloc>(
            create: (_) => CategoryBloc(getIt<GetAllCategoriesUsecase>(),
                getIt<FetchSubCategoriesUsecase>())
              ..add(LoadCategories())),

        ///Banner
        BlocProvider<BannerBloc>(
            create: (_) =>
                BannerBloc(getIt<GetAllBannersUsecase>())..add(LoadBanners())),

        BlocProvider<ProductBloc>(
            create: (_) => ProductBloc(
                getIt<FetchAllProductsUsecase>(),
                getIt<FetchProductByIdUsecase>(),
                getIt<FetchAllBrandsUsecase>(),
                getIt<FetchBrandByIdUsecase>(),
                getIt<FetchVariationByProductIdUsecase>(),
                getIt<FilterProductsUsecase>(),
                getIt<FetchProductByCategoryIdUsecase>())
              ..add(FetchAllProducts())
              ..add(FetchAllBrands())),

        BlocProvider<WishlistBloc>(
            create: (_) => WishlistBloc(
                  getIt<GetWishListUsecase>(),
                  getIt<RemoveWishlistItemUsecase>(),
                  getIt<SaveWishlistItemUsecase>(),
                )..add(const LoadWishlist())),
        BlocProvider<AddressBloc>(
          create: (_) => AddressBloc(
              getIt<SaveAddressUsecase>(),
              getIt<GetCurrentUserUsecase>(),
              getIt<FetchAddressUsecase>(),
              getIt<RemoveAddressUsecase>(),
              getIt<UpdateAddressUsecase>())
            ..add(LoadAddress()),
        ),

        BlocProvider<CartBloc>(create: (_) {
          final addressBloc = AddressBloc(
            getIt<SaveAddressUsecase>(),
            getIt<GetCurrentUserUsecase>(),
            getIt<FetchAddressUsecase>(),
            getIt<RemoveAddressUsecase>(),
            getIt<UpdateAddressUsecase>(),
          )..add(LoadAddress());

          return CartBloc(
              getIt<AddToCartUsecase>(),
              getIt<GetCartItemUsecase>(),
              getIt<UpdateQuantityUsecase>(),
              getIt<RemoveCartItemUsecase>(),
              getIt<ClearCartUsecase>(),
              getIt<GetVariationIdAttributesUsecase>(),
              getIt<FetchVariationUsecase>(),
              getIt<FetchBrandByIdUsecase>(),
              getIt<SelectPaymentMethodUsecase>(),
              getIt<CreatePaymentIntentUsecase>(),
              getIt<CreateInvoiceUsecase>(),
              addressBloc,
              getIt<FetchPaymentMethodUsecase>(),
            getIt<GetCurrentUserUsecase>(),
            getIt<SendOrderConfirmationEmailUsecase>()
          )
            ..add(LoadCart());
        }),

        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(
              getIt<SearchProductUsecase>(), getIt<FetchSuggestionsUsecase>()),
        )
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router, // Sử dụng GoRouter
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
