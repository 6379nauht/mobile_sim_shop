import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_sim_shop/features/auth/data/local_sources/auth_local_service.dart';
import 'package:mobile_sim_shop/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile_sim_shop/features/auth/data/sources/auth_firebase_service.dart';
import 'package:mobile_sim_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/check_email_verification_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/save_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signin_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signin_with_google_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signout_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signup_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/data/repositories/address_repository_impl.dart';
import 'package:mobile_sim_shop/features/personalization/data/repositories/profile_repository_impl.dart';
import 'package:mobile_sim_shop/features/personalization/data/sources/address_firebase_service.dart';
import 'package:mobile_sim_shop/features/personalization/data/sources/profile_firebase_service.dart';
import 'package:mobile_sim_shop/features/personalization/domain/repositories/address_repository.dart';
import 'package:mobile_sim_shop/features/personalization/domain/repositories/profile_repository.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/delete_account_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/fetch_adddresss_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/remove_address_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/save_address_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/update_address_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/update_user_usecase.dart';
import 'package:mobile_sim_shop/features/store/data/local_sources/cart_local_service.dart';
import 'package:mobile_sim_shop/features/store/data/local_sources/wishlist_local_service.dart';
import 'package:mobile_sim_shop/features/store/data/models/fetch_variation_params.dart';
import 'package:mobile_sim_shop/features/store/data/models/remove_cart_item.dart';
import 'package:mobile_sim_shop/features/store/data/repositories/banner_repository_impl.dart';
import 'package:mobile_sim_shop/features/store/data/repositories/cart_repository_impl.dart';
import 'package:mobile_sim_shop/features/store/data/repositories/category_repository_impl.dart';
import 'package:mobile_sim_shop/features/store/data/repositories/product_repository_impl.dart';
import 'package:mobile_sim_shop/features/store/data/repositories/wishlist_repository_impl.dart';
import 'package:mobile_sim_shop/features/store/data/sources/banner_firebase_service.dart';
import 'package:mobile_sim_shop/features/store/data/sources/cart_firebase_servive.dart';
import 'package:mobile_sim_shop/features/store/data/sources/category_firebase_service.dart';
import 'package:mobile_sim_shop/features/store/data/sources/product_firebase_service.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/cart_repository.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/category_repository.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/product_repository.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/wishlist_repository.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/add_to_cart_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/clear_cart_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/create_invoice_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/create_payment_intent_usecase.dart';
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
import 'package:mobile_sim_shop/features/store/domain/usecases/select_payment_method_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/send_order_confirmation_email_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/update_quantity_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typesense/typesense.dart';
import '../../features/personalization/data/sources/imgur_data_source.dart';
import '../../features/store/domain/repositories/banner_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  /// Services
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  final prefs = await SharedPreferences.getInstance();
  getIt
      .registerSingleton<AuthLocalDataService>(AuthLocalDataServiceImpl(prefs));

  /// Đăng ký http.Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<ProfileFirebaseService>(
      () => ProfileFirebaseServiceImpl(
            firestore: getIt<FirebaseFirestore>(),
            firebaseAuth: getIt<FirebaseAuth>(),
            imgurDataSource: getIt<ImgurDataSource>(),
          ));
  getIt.registerSingleton<CategoryFirebaseService>(
      CategoryFirebaseServiceImpl());
  getIt.registerSingleton<BannerFirebaseService>(BannerFirebaseServiceImpl());

  final typesenseClient = Client(Configuration(
    'xyz123',
    nodes: {Node.withUri(Uri.parse('http://192.168.2.1:8108'))},
    connectionTimeout: const Duration(seconds: 2),
  ));
  getIt.registerSingleton<ProductFirebaseService>(
      ProductFirebaseServiceImpl(typesenseClient));
  getIt
      .registerSingleton<WishlistLocalService>(WishlistLocalServiceImpl(prefs));
  getIt.registerSingleton<AddressFirebaseService>(AddressFirebaseServiceImpl());
  getIt.registerSingleton<CartLocalService>(CartLocalServiceImpl(prefs));
  getIt.registerSingleton<CartFirebaseService>(CartFirebaseServiceImpl());

  /// Repository
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  getIt.registerLazySingleton<ImgurDataSource>(() => ImgurDataSourceImpl(
        client: getIt<http.Client>(),
        clientId: '30895b0dfa7aacd', // Thay bằng Client-ID thực tế
      ));
  // Đăng ký ProfileRepository
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
        profileFirebaseService: getIt<ProfileFirebaseService>(),
      ));

  ///CategoryRepository
  getIt.registerSingleton<CategoryRepository>(CategoryRepositoryImpl());

  ///BannerRepository
  getIt.registerSingleton<BannerRepository>(BannerRepositoryImpl());

  ///ProductRepository
  getIt.registerSingleton<ProductRepository>(ProductRepositoryImpl());
  getIt.registerSingleton<WishlistRepository>(WishlistRepositoryImpl());
  getIt.registerSingleton<AddressRepository>(AddressRepositoryImpl());
  getIt.registerSingleton<CartRepository>(CartRepositoryImpl());

  /// Usecase
  getIt.registerSingleton<SignupUseCase>(SignupUseCase());
  getIt.registerSingleton<CheckEmailVerifiedUsecase>(
      CheckEmailVerifiedUsecase());
  getIt.registerSingleton<DeleteUserUsecase>(DeleteUserUsecase());
  getIt.registerSingleton<SaveRememberMeUseCase>(SaveRememberMeUseCase());
  getIt.registerSingleton<GetRememberMeUseCase>(GetRememberMeUseCase());
  getIt.registerSingleton<SigninUsecase>(SigninUsecase());
  getIt.registerSingleton<GetCurrentUserUsecase>(GetCurrentUserUsecase());
  getIt.registerSingleton<SignOutUsecase>(SignOutUsecase());
  getIt.registerSingleton<SignInWithGoogleUsecase>(SignInWithGoogleUsecase());
  getIt.registerSingleton<ResetPasswordUsecase>(ResetPasswordUsecase());
  getIt.registerLazySingleton<UpdateUserUsecase>(() => UpdateUserUsecase(
        getIt<ProfileRepository>(),
      ));
  getIt.registerSingleton<DeleteAccountUsecase>(DeleteAccountUsecase());
  getIt.registerSingleton<GetAllCategoriesUsecase>(GetAllCategoriesUsecase());
  getIt.registerSingleton<GetAllBannersUsecase>(GetAllBannersUsecase());
  getIt.registerSingleton<FetchAllBrandsUsecase>(FetchAllBrandsUsecase());
  getIt.registerSingleton<FetchAllProductsUsecase>(FetchAllProductsUsecase());
  getIt.registerSingleton<FetchProductByIdUsecase>(FetchProductByIdUsecase());
  getIt.registerSingleton<FetchBrandByIdUsecase>(FetchBrandByIdUsecase());
  getIt.registerSingleton<FetchVariationByProductIdUsecase>(
      FetchVariationByProductIdUsecase());
  getIt.registerSingleton<FilterProductsUsecase>(FilterProductsUsecase());
  getIt.registerSingleton<FetchSubCategoriesUsecase>(
      FetchSubCategoriesUsecase());
  getIt.registerSingleton<FetchProductByCategoryIdUsecase>(
      FetchProductByCategoryIdUsecase());
  getIt.registerSingleton<GetWishListUsecase>(GetWishListUsecase());
  getIt.registerSingleton<RemoveWishlistItemUsecase>(
      RemoveWishlistItemUsecase());
  getIt.registerSingleton<SaveWishlistItemUsecase>(SaveWishlistItemUsecase());
  getIt.registerSingleton<SaveAddressUsecase>(SaveAddressUsecase());
  getIt.registerSingleton<RemoveAddressUsecase>(RemoveAddressUsecase());
  getIt.registerSingleton<UpdateAddressUsecase>(UpdateAddressUsecase());
  getIt.registerSingleton<FetchAddressUsecase>(FetchAddressUsecase());
  getIt.registerSingleton<GetCartItemUsecase>(GetCartItemUsecase());
  getIt.registerSingleton<AddToCartUsecase>(AddToCartUsecase());
  getIt.registerSingleton<UpdateQuantityUsecase>(UpdateQuantityUsecase());
  getIt.registerSingleton<RemoveCartItemUsecase>(RemoveCartItemUsecase());
  getIt.registerSingleton<ClearCartUsecase>(ClearCartUsecase());
  getIt.registerSingleton<GetVariationIdAttributesUsecase>(
      GetVariationIdAttributesUsecase());
  getIt.registerSingleton<FetchVariationUsecase>(FetchVariationUsecase());
  getIt.registerSingleton<SearchProductUsecase>(SearchProductUsecase());
  getIt.registerSingleton<FetchSuggestionsUsecase>(FetchSuggestionsUsecase());
  getIt.registerSingleton<CreatePaymentIntentUsecase>(
      CreatePaymentIntentUsecase());
  getIt.registerSingleton<SelectPaymentMethodUsecase>(
      SelectPaymentMethodUsecase());
  getIt.registerSingleton<CreateInvoiceUsecase>(CreateInvoiceUsecase());
  getIt.registerSingleton<FetchPaymentMethodUsecase>(
      FetchPaymentMethodUsecase());
  getIt.registerSingleton<SendOrderConfirmationEmailUsecase>(SendOrderConfirmationEmailUsecase());
}
