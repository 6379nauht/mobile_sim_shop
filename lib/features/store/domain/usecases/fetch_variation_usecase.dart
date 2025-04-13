import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/fetch_variation_params.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/product_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class FetchVariationUsecase extends UseCase<Either, FetchVariationParams>{
  @override
  Future<Either> call({FetchVariationParams? params}) async {
    return await getIt<ProductRepository>().fetchVariation(params!);
  }

}