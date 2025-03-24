import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:mobile_sim_shop/features/personalization/data/repositories/profile_repository_impl.dart';
import 'package:mobile_sim_shop/features/personalization/data/sources/profile_firebase_service.dart';
import 'package:mobile_sim_shop/features/personalization/domain/repositories/profile_repository.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/delete_account_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/update_user_usecase.dart';
import 'package:mobile_sim_shop/features/store/data/repositories/category_repository_impl.dart';
import 'package:mobile_sim_shop/features/store/data/sources/category_firebase_service.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/category_repository.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_all_categories_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/personalization/data/sources/imgur_data_source.dart';

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
  getIt.registerSingleton<CategoryFirebaseService>(CategoryFirebaseServiceImpl());

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
}
