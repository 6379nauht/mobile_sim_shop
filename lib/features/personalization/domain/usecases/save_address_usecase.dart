import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/save_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/domain/repositories/address_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class SaveAddressUsecase extends UseCase<Either, SaveAddressParams> {
  @override
  Future<Either> call({SaveAddressParams? params}) async{
    return await getIt<AddressRepository>().saveAddress(params!);
  }

}