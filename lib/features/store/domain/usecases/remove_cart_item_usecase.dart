import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/remove_cart_item.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/cart_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class RemoveCartItemUsecase extends UseCase<Either, RemoveCartItemParams> {
  @override
  Future<Either> call({RemoveCartItemParams? params}) async{
    return await getIt<CartRepository>().removeCartItem(params!);
  }
}