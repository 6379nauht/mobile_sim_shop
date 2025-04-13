import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/get_variation_id_attributes_params.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/product_repository.dart';

class GetVariationIdAttributesUsecase extends UseCase<Either, GetVariationIdAttributesParams>{
  @override
  Future<Either> call({GetVariationIdAttributesParams? params}) async{
    return await getIt<ProductRepository>().getVariationIdFromAttributes(params!);
  }

}