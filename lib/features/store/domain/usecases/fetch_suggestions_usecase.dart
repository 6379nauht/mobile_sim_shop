import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/product_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class FetchSuggestionsUsecase extends UseCase<Either, String>{
  @override
  Future<Either> call({String? params}) async {
    return await getIt<ProductRepository>().fetchSuggestions(params!);
  }
}