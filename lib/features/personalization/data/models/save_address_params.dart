import 'package:mobile_sim_shop/features/personalization/data/models/address_model.dart';

class SaveAddressParams {
  final String userId;
  final AddressModel address;
  SaveAddressParams({required this.userId, required this.address});
}