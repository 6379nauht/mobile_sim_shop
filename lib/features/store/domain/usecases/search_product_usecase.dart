import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/search_product_params.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/product_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class SearchProductUsecase extends UseCase<Either, SearchProductParams>{
  @override
  Future<Either> call({SearchProductParams? params}) async{
    return await getIt<ProductRepository>().searchProducts(params!);
  }
}