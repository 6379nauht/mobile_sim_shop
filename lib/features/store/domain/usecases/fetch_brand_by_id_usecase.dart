import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';

import '../../../../core/dependency_injection/locator.dart';
import '../repositories/product_repository.dart';


class FetchBrandByIdUsecase implements UseCase<Either, String>{
  @override
  Future<Either> call({String? params}) async {
    return await getIt<ProductRepository>().fetchBrandById(params!);
  }


}