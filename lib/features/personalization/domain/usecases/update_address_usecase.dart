import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/update_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/domain/repositories/address_repository.dart';

class UpdateAddressUsecase extends UseCase<Either, UpdateAddressParams> {
  @override
  Future<Either> call({UpdateAddressParams? params}) async{
    return await getIt<AddressRepository>().updateAddress(params!);
  }
}