import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/banner_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class GetAllBannersUsecase extends UseCase<Either, NoParams>{
  @override
  Future<Either> call({NoParams? params}) async {
    return await getIt<BannerRepository>().getAllBanner();
  }

}