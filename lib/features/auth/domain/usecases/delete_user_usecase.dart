
import 'package:dartz/dartz.dart';

import '../../../../core/dependency_injection/locator.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class DeleteUserUsecase implements UseCase<Either, UserModel> {
  @override
  Future<Either<Failure, void>> call({UserModel? params}) async {
    return await getIt<AuthRepository>().deleteUser(params!);
  }
}