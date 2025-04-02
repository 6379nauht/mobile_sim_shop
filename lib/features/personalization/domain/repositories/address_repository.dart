import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/address_model.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/save_address_params.dart';

import '../../data/models/remove_address_params.dart';
import '../../data/models/update_address_params.dart';

abstract class AddressRepository {
  Future<Either<Failure, void>> saveAddress(SaveAddressParams params);
  Stream<Either<Failure, List<AddressModel>>> fetchAddresses(String userId);
  Future<Either<Failure, void>> removeAddress(RemoveAddressParams params);
  Future<Either<Failure, void>> updateAddress(UpdateAddressParams params);
}