import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/category_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class FetchSubCategories extends UsecaseStream<Either, String> {
  @override
  Stream<Either> call({String? params}) {
    return getIt<CategoryRepository>().fetchSubCategories(params!);
  }

}