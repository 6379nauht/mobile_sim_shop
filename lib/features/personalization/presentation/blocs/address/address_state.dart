import 'package:equatable/equatable.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/address_model.dart';

import '../../../../auth/data/models/user_model.dart';

enum AddressStatus {initial, loading, success, failure}
class AddressState extends Equatable {
  final List<AddressModel> addresses;
  final UserModel? user;
  final String? errorMessage;
  final AddressStatus status;
  const AddressState({
    this.addresses = const [],
    this.errorMessage,
    this.user,
    this.status = AddressStatus.initial
});

  AddressState copyWith ({
    List<AddressModel>? addresses,
    String? errorMessage,
    UserModel? user,
    AddressStatus? status,
  }) {
    return AddressState(
        addresses: addresses ?? this.addresses,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      user: user ?? this.user
    );
  }
  @override
  List<Object?> get props => [addresses, errorMessage, status, user];

}