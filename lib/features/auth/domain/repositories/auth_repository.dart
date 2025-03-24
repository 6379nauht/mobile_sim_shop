import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/features/auth/data/models/save_email_model.dart';
import '../../data/models/user_model.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart'; // Import Failure

abstract class AuthRepository {
  // sign up
  Future<Either<Failure, UserModel>> signup(UserModel user);

  // check email xác minh
  Future<Either<Failure, void>> checkEmailVerified();

  //delete account
  Future<Either<Failure, void>> deleteUser(UserModel user);

  //Sign in
  Future<Either<Failure,UserModel>> signin(UserModel user);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserModel?>> getCurrentUser();

  //RememberMe
  Future<Either<Failure, void>> saveRememberMe(SaveEmailModel remember);
  Future<Either<Failure, SaveEmailModel>> getRememberMe();
  Future<Either<Failure, UserModel>> signInWithGoogle();
  Future<Either<Failure, void>> resetPassword(String email);

}
