import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/payment_method.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/cart_repository.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/product_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class SelectPaymentMethodUsecase extends UseCase<Either,PaymentMethod> {
  @override
  Future<Either> call({PaymentMethod? params}) async{
    return await getIt<CartRepository>().selectPaymentMethod(params!);
  }

}