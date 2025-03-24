import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/category_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class GetAllCategoriesUsecase implements UseCase<Either, NoParams>{
  @override
  Future<Either> call({NoParams? params}) async{
    return await getIt<CategoryRepository>().getAllCategories();
  }

}