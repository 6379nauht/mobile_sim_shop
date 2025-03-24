import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/update_user_params.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserModel>> updateUser(UpdateUserParams user);
  Future<Either<Failure, void>> deleteAccount(String? password);
}