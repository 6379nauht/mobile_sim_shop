import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/remove_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/domain/repositories/address_repository.dart';

class RemoveAddressUsecase extends UseCase<Either, RemoveAddressParams> {
  @override
  Future<Either> call({RemoveAddressParams? params}) async{
    return await getIt<AddressRepository>().removeAddress(params!);
  }

}