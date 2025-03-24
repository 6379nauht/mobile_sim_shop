import 'package:dartz/dartz.dart';

import 'package:mobile_sim_shop/core/errors/failures.dart';

import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/update_user_params.dart';
import 'package:mobile_sim_shop/features/personalization/data/sources/profile_firebase_service.dart';

import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileFirebaseService profileFirebaseService;

  ProfileRepositoryImpl({required this.profileFirebaseService});

  @override
  Future<Either<Failure, UserModel>> updateUser(UpdateUserParams params) async {
    return await profileFirebaseService.updateUser(params);
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String? password) async{
    return await profileFirebaseService.deleteAccount(password);
  }
}