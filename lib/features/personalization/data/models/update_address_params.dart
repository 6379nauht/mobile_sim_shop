import 'address_model.dart';

class UpdateAddressParams {
  final String userId;
  final AddressModel address;
  final String addressId;
  UpdateAddressParams({required this.userId, required this.address, required this.addressId});
}