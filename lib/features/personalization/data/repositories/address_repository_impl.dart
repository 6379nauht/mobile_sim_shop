import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/address_model.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/remove_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/save_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/update_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/data/sources/address_firebase_service.dart';
import 'package:mobile_sim_shop/features/personalization/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressFirebaseService _firebaseService = getIt<AddressFirebaseService>();
  @override
  Future<Either<Failure, void>> saveAddress(SaveAddressParams params) async{
    return await _firebaseService.saveAddress(params);
  }

  @override
  Stream<Either<Failure, List<AddressModel>>> fetchAddresses(String userId) {
    return _firebaseService.fetchAddresses(userId);
  }

  @override
  Future<Either<Failure, void>> removeAddress(RemoveAddressParams params) async {
    return _firebaseService.removeAddress(params);
  }

  @override
  Future<Either<Failure, void>> updateAddress(UpdateAddressParams params) {
    return _firebaseService.updateAddress(params);
  }

}