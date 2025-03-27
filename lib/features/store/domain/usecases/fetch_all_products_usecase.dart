import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/product_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class FetchAllProductsUsecase implements UsecaseStream<Either<Failure, List<ProductModel>>, NoParams>{
  @override
  Stream<Either<Failure, List<ProductModel>>> call({NoParams? params}) {
    return getIt<ProductRepository>().fetchAllProducts();
  }
}