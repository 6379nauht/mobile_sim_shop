import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/repositories/address_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class FetchAddressUsecase extends UsecaseStream<Either, String> {
  @override
  Stream<Either> call({String? params}) {
    return getIt<AddressRepository>().fetchAddresses(params!);
  }

}