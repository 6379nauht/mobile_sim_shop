import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/create_payment_intent_params.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/cart_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class CreatePaymentIntentUsecase extends UseCase<Either, CreatePaymentIntentParams>{
  @override
  Future<Either> call({CreatePaymentIntentParams? params}) async{
    return await getIt<CartRepository>().createPaymentIntent(params!);
  }

}