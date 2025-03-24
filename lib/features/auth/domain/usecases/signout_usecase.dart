import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/repositories/auth_repository.dart';

class SignOutUsecase implements UseCase<Either, NoParams> {
  @override
  Future<Either> call({NoParams? params}) async {
    return await getIt<AuthRepository>().signOut();
  }

}