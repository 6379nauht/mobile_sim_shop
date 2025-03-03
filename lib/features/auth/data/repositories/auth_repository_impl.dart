import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/features/auth/data/local_sources/auth_local_service.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/auth/data/sources/auth_firebase_service.dart';
import 'package:mobile_sim_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';

import '../models/save_email_model.dart';
// Import Failure

class AuthRepositoryImpl extends AuthRepository {

  // Đăng ký tài khoản
  @override
  Future<Either<Failure, UserModel>> signup(UserModel user) async {
    return await getIt<AuthFirebaseService>().signup(user);
  }

  // Gửi email xác minh
  @override
  Future<Either<Failure, void>> checkEmailVerified() async {
    return await getIt<AuthFirebaseService>().checkEmailVerified();
  }

  @override
  Future<Either<Failure, void>> deleteUser(UserModel user) async {
    return await getIt<AuthFirebaseService>().deleteUser(user);
  }

  @override
  Future<Either<Failure, UserModel>> signin(UserModel user) async{
    return await getIt<AuthFirebaseService>().signin(user);
  }

  @override
  Future<Either<Failure, SaveEmailModel>> getRememberMe() async{
    return await getIt<AuthLocalDataService>().getRememberMe();
  }

  @override
  Future<Either<Failure, void>> saveRememberMe(SaveEmailModel remember) async{
    return await getIt<AuthLocalDataService>().saveRememberMe(remember);
  }
  

}
