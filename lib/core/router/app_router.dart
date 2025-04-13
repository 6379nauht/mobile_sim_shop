import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/core/widgets/address/address_form.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_state.dart';
import 'package:mobile_sim_shop/features/auth/presentation/pages/signin/signin.dart';
import 'package:mobile_sim_shop/features/auth/presentation/pages/signup/signup.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/address/address.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/profile/profile.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/settings/settings.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/all_products/all_products.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/brand/all_brands.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/brand/brand_products.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/cart/cart.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/checkout/checkout.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/home.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/order/order.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/product_details/product_details.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/search/search.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/store/store.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/sub_category/sub_categories.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/wishlist/wishlist.dart';

import '../../features/auth/presentation/pages/password_configuration/forget_password.dart';
import '../../features/auth/presentation/pages/password_configuration/reset_password.dart';
import '../../features/auth/presentation/pages/signup/verify_email.dart';
import '../../features/personalization/data/models/address_model.dart';
import '../../features/store/data/models/brand_model.dart';
import '../../navigation_menu.dart';
import '../utils/constants/image_strings.dart';
import '../utils/constants/text_strings.dart';
import '../widgets/success_page/success_page.dart';

class AppRouter {
  AppRouter._(); // Private constructor to prevent instantiation

  // Make router a static field so it can be accessed without creating an instance
  static final GoRouter router = GoRouter(
    initialLocation: Routes.initialRoute, // Thay đổi thành route khởi đầu
    redirect: (context, state) {
      final authBloc = context.read<SigninBloc>();
      final authState = authBloc.state;
      // Xử lý route khởi đầu đặc biệt
      if (state.matchedLocation == Routes.initialRoute) {
        // Điều hướng dựa trên trạng thái đăng nhập
        return authState.status == SigninStatus.authenticated
            ? Routes.home
            : Routes.signin;
      }
      // Kiểm tra trạng thái đăng nhập
      if (authState.status == SigninStatus.authenticated) {
        // Nếu đã đăng nhập, chuyển đến Home
        if (state.matchedLocation == Routes.signin ||
            state.matchedLocation == Routes.signup) {
          return Routes.home;
        }
      } else if (authState.status == SigninStatus.unauthenticated) {
        // Nếu chưa đăng nhập, chỉ cho phép truy cập các trang auth
        if (![
          Routes.signin,
          Routes.signup,
          Routes.forgetPassword,
          Routes.resetPassword,
          Routes.verifyEmail,
          Routes.verifySuccess,
        ].contains(state.matchedLocation)) {
          return Routes.signin;
        }
      }
      return null; // Không redirect nếu không cần
    },
    routes: [
// Thêm route khởi đầu
      GoRoute(
        path: Routes.initialRoute,
        pageBuilder: (context, state) {
          // Trang này chỉ là cầu nối, sẽ không được hiển thị
          // vì redirect sẽ chạy ngay lập tức
          return const NoTransitionPage(
            child: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        },
      ),
      ///Authentication
      ///SignIn
      GoRoute(
          path: Routes.signin,
          name: Routes.signinName,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SigninPage())),

      ///SignUp
      GoRoute(
        path: Routes.signup,
        name: Routes.signupName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SignupPage()),
      ),

      ///ForgetPass
      GoRoute(
        path: Routes.forgetPassword,
        name: Routes.forgetPasswordName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ForgetPasswordPage()),
      ),

      ///ResetPass
      GoRoute(
        path: Routes.resetPassword,
        name: Routes.resetPasswordName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ResetPasswordPage()),
      ),

      ///VerifyEmail
      GoRoute(
        path: Routes.verifyEmail,
        name: Routes.verifyEmailName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: VerifyEmailPage()),
      ),

      ///Verify Successful
      GoRoute(
        path: Routes.verifySuccess,
        name: Routes.verifySuccessName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: SuccessPage(
            image: AppImages.success,
            title: AppTexts.accountSuccessTitle,
            subTitle: AppTexts.accountSuccessSubTitle,
            onPressed: () => context.goNamed(Routes.signinName),
          ),
        ),
      ),



      ///Personal
      GoRoute(
          path: Routes.profile,
          name: Routes.profileName,
          pageBuilder: (_, state) =>
              const NoTransitionPage(child: ProfilePage())),
      GoRoute(
          path: Routes.address,
          name: Routes.addressName,
          pageBuilder: (_, state) =>
          const NoTransitionPage(child: UserAddressPage())),
      GoRoute(
          path: Routes.addNewAddress,
          name: Routes.addNewAddressName,
          pageBuilder: (_, state) {
            final userId = state.extra as String? ?? '';
            return NoTransitionPage(child: AddressFormPage(userId: userId,));
          }),

      GoRoute(
        path: Routes.editAddress,
        name: Routes.editAddressName,
        pageBuilder: (_, state) {
          final args = state.extra as Map<String, dynamic>?;
          return NoTransitionPage(
            child: AddressFormPage(
              userId: args?['userId'] ?? '',
              address: args?['address'] as AddressModel?, // Ép kiểu thành AddressModel
              isEditMode: true, // Luôn là edit mode
            ),
          );
        },
      ),

      ///Store
      GoRoute(
          path: Routes.productDetails,
          name: Routes.productDetailsName,
          pageBuilder: (_, state) {
            final ProductModel product = state.extra as ProductModel? ?? ProductModel.empty();
            return NoTransitionPage(child: ProductDetailsPage(product: product,));
            }),


      GoRoute(
          path: Routes.cart,
          name: Routes.cartName,
          pageBuilder: (_, state) =>
          const NoTransitionPage(child: CartPage())),
      GoRoute(
          path: Routes.checkout,
          name: Routes.checkoutName,
          pageBuilder: (_, state) =>
          const NoTransitionPage(child: CheckoutPage())),
      GoRoute(
        path: Routes.checkoutSuccess,
        name: Routes.checkoutSuccessName,
        pageBuilder: (context, state) => NoTransitionPage(
          child: SuccessPage(
            image: AppImages.success,
            title: 'Thanh toán thành công',
            subTitle: 'Đơn hàng của bạn sẽ được giao đến bạn sớm nhất',
            onPressed: () => context.goNamed(Routes.homeName),
          ),
        ),
      ),
      GoRoute(
          path: Routes.subCategories,
          name: Routes.subCategoriesName,
          pageBuilder: (_, state) {
            final  CategoryModel category =
                state.extra as CategoryModel? ?? CategoryModel.empty();
            return NoTransitionPage(child: SubCategoriesPage(category: category));
          }),

      GoRoute(
          path: Routes.order,
          name: Routes.orderName,
          pageBuilder: (_, state) =>
          const NoTransitionPage(child: OrderPage())),
      GoRoute(
          path: Routes.allProducts,
          name: Routes.allProductsName,
          pageBuilder: (_, state) {
            final  CategoryModel category =
            state.extra as CategoryModel? ?? CategoryModel.empty();
            return NoTransitionPage(child: AllProductsPage(category: category));
          }
          ),
      GoRoute(
          path: Routes.allBrands,
          name: Routes.allBrandsName,
          pageBuilder: (_, state) =>
          const NoTransitionPage(child: AllBrandsPage())),
      GoRoute(
          path: Routes.brandProducts,
          name: Routes.brandProductsName,
          pageBuilder: (_, state) {
            final BrandModel brand = state.extra as BrandModel? ?? BrandModel.empty();
            return NoTransitionPage(child: BrandProducts(brand: brand,));
            }
          ),
      ///search
      GoRoute(
          path: Routes.search,
          name: Routes.searchName,
          pageBuilder: (_, state) =>
          const NoTransitionPage(child: SearchPage())),

      ///BottomNavigation
      ShellRoute(
        builder: (context, state, child) {
          return NavigationMenu(child: child);
        },
        routes: [
          GoRoute(
            path: Routes.home,
            name: Routes.homeName,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: Routes.store,
            name: Routes.storeName,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StorePage(),
            ),
          ),
          GoRoute(
            path: Routes.wishlist,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FavouritePage(),
            ),
          ),
          GoRoute(
              path: Routes.settings,
              pageBuilder: (_, state) =>
                  const NoTransitionPage(child: SettingsPage()))
        ],
      ),
    ],
  );
}
