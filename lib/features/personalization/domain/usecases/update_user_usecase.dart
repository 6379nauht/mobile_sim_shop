import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/update_user_params.dart';
import 'package:mobile_sim_shop/features/personalization/domain/repositories/profile_repository.dart';

import '../../../../core/errors/failures.dart';

class UpdateUserUsecase {
  final ProfileRepository repository;

  UpdateUserUsecase(this.repository);

  Future<Either<Failure, UserModel>> call({required UpdateUserParams params}) async {
    return await repository.updateUser(params);
  }
}