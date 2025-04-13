import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/cart_item_model.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/cart_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class AddToCartUsecase extends UseCase<Either, CartItemModel> {
  @override
  Future<Either> call({CartItemModel? params}) async {
    return await getIt<CartRepository>().addToCart(params!);
  }
}
