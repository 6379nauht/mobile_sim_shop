import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/product_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class FetchAllBrandsUsecase implements UsecaseStream<Either, NoParams>{
  @override
  Stream<Either> call({NoParams? params}) {
    return getIt<ProductRepository>().fetchAllBrands();
  }
}