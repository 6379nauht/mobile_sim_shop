import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/send_order_confirmation_email_params.dart';
import 'package:mobile_sim_shop/features/store/data/sources/cart_firebase_servive.dart';

import '../../../../core/dependency_injection/locator.dart';

class SendOrderConfirmationEmailUsecase extends UseCase<Either, SendOrderConfirmationEmailParams> {
  @override
  Future<Either> call({SendOrderConfirmationEmailParams? params}) async{
    return await getIt<CartFirebaseService>().sendOrderConfirmationEmail(params!);
  }
}