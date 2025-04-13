import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/update_quantity_params.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/cart_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class UpdateQuantityUsecase extends UseCase<Either, UpdateQuantityParams> {
  @override
  Future<Either> call({UpdateQuantityParams? params})async {
    return await getIt<CartRepository>().updateQuantity(params!);
  }
}