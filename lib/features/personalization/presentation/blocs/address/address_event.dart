import 'package:equatable/equatable.dart';

import '../../../data/models/address_model.dart';
import '../../../data/models/remove_address_params.dart';
import '../../../data/models/update_address_params.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddress extends AddressEvent {}

class SaveAddressEvent extends AddressEvent {
  final String userId;
  final AddressModel address;

  const SaveAddressEvent(this.userId, this.address);
  @override
  List<Object?> get props => [userId, address];
}

class FetchAddressesEvent extends AddressEvent {
  final String userId;

  const FetchAddressesEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RemoveAddressEvent extends AddressEvent {
  final RemoveAddressParams params;

  const RemoveAddressEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateAddressEvent extends AddressEvent {
  final UpdateAddressParams params;

  const UpdateAddressEvent(this.params);

  @override
  List<Object?> get props => [params];
}

// Trong address_event.dart
class SelectAddressEvent extends AddressEvent {
  final String userId;
  final String addressId;

  const SelectAddressEvent(this.userId, this.addressId);

  @override
  List<Object?> get props => [userId, addressId];
}