import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart'; // Import Failure

class CheckEmailVerifiedUsecase implements UseCase<Either<Failure, void>, NoParams> {
  @override
  Future<Either<Failure, void>> call({NoParams? params}) async {
    return await getIt<AuthRepository>().checkEmailVerified();
  }
}
