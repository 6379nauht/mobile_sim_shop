import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/repositories/profile_repository.dart';

class DeleteAccountUsecase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await getIt<ProfileRepository>().deleteAccount(params);
  }

}