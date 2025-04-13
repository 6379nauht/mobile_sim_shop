import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/data/sources/cart_firebase_servive.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/invoice.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/cart_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class CreateInvoiceUsecase extends UseCase<Either, Invoice>{
  @override
  Future<Either> call({Invoice? params}) async {
    return await getIt<CartRepository>().createInvoice(params!);
  }
}