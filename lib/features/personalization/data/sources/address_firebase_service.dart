import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/remove_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/update_address_params.dart';

import '../../../../core/dependency_injection/locator.dart';
import '../../../../core/errors/failures.dart';
import '../models/save_address_params.dart';
import '../models/address_model.dart'; // Giả sử bạn có AddressModel

abstract class AddressFirebaseService {
  Future<Either<Failure, void>> saveAddress(SaveAddressParams params);
  Stream<Either<Failure, List<AddressModel>>> fetchAddresses(String userId);
  Future<Either<Failure, void>> removeAddress(RemoveAddressParams params);
  Future<Either<Failure, void>> updateAddress(UpdateAddressParams params);
}

class AddressFirebaseServiceImpl extends AddressFirebaseService {
  @override
  Future<Either<Failure, void>> saveAddress(SaveAddressParams params) async {
    try {
      final addressRef = getIt<FirebaseFirestore>()
          .collection('users')
          .doc(params.userId)
          .collection('addresses')
          .doc();

      await addressRef.set(params.address.toJson());

      final updatedAddress = params.address.copyWith(id: addressRef.id);
      await addressRef.set(updatedAddress.toJson(), SetOptions(merge: true));

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Không thể lưu địa chỉ: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, List<AddressModel>>> fetchAddresses(String userId) {
    final Stream<Either<Failure, List<AddressModel>>> stream = getIt<FirebaseFirestore>()
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .snapshots()
        .map((snapshot) {
      try {
        final address = snapshot.docs
            .map((doc) => AddressModel.fromSnapshot(doc))
            .toList();
        return Right<Failure, List<AddressModel>>(address);
      } catch (e) {
        return Left<Failure, List<AddressModel>>(ServerFailure( 'Error streaming products: $e'));
      }
    })
        .handleError((e) {
      return Left<Failure, List<AddressModel>>(ServerFailure('Stream error: $e'));
    });
    return stream;
  }

  @override
  Future<Either<Failure, void>> removeAddress(RemoveAddressParams params) async {
    try {
      await getIt<FirebaseFirestore>()
          .collection('users')
          .doc(params.userId)
          .collection('addresses')
          .doc(params.addressId)
          .delete();

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Không thể xóa địa chỉ: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddress(UpdateAddressParams params) async {
    try {
      final addressRef = getIt<FirebaseFirestore>()
          .collection('users')
          .doc(params.userId)
          .collection('addresses')
          .doc(params.addressId);

      // Cập nhật thông tin địa chỉ với merge để giữ lại các field không thay đổi
      final updatedAddress = params.address.copyWith(id: params.addressId);
      await addressRef.set(updatedAddress.toJson(), SetOptions(merge: true));

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Không thể cập nhật địa chỉ: ${e.toString()}'));
    }
  }
}