
import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/auth/data/models/save_email_model.dart';
import 'package:mobile_sim_shop/features/auth/domain/repositories/auth_repository.dart';

class SaveRememberMeUseCase implements UseCase<Either, SaveEmailModel> {
  @override
  Future<Either> call({SaveEmailModel? params}) async {
    return await getIt<AuthRepository>().saveRememberMe(params!);
  }
}