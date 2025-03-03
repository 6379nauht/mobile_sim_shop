import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_sim_shop/features/auth/data/local_sources/auth_local_service.dart';
import 'package:mobile_sim_shop/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile_sim_shop/features/auth/data/sources/auth_firebase_service.dart';
import 'package:mobile_sim_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/check_email_verification_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/save_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signup_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';


final getIt = GetIt.instance;

Future<void> setupLocator() async {
  ///Services
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  getIt.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());

  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<AuthLocalDataService>(AuthLocalDataServiceImpl(prefs));



  ///Repository
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());




  ///Usecase
  getIt.registerSingleton<SignupUseCase>(SignupUseCase());
  getIt.registerSingleton<CheckEmailVerifiedUsecase>(CheckEmailVerifiedUsecase());
  getIt.registerSingleton<DeleteUserUsecase>(DeleteUserUsecase());
  getIt.registerSingleton<SaveRememberMeUseCase>(SaveRememberMeUseCase());
  getIt.registerSingleton<GetRememberMeUseCase>(GetRememberMeUseCase());
}
