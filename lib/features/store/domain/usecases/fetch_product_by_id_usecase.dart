import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/product_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class FetchProductByIdUsecase implements UsecaseStream<Either, String>{
  @override
  Stream<Either> call({String? params}) {
    return getIt<ProductRepository>().fetchVariationByProductId(params!);
  }
}