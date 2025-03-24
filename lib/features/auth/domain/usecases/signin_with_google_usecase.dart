import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class SignInWithGoogleUsecase implements UseCase<Either, UserModel> {
  @override
  Future<Either> call({UserModel? params}) async {
    // TODO: implement call
    return await getIt<AuthRepository>().signInWithGoogle();
  }
  
}