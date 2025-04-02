import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/remove_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/save_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/update_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/fetch_adddresss_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/remove_address_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/save_address_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/update_address_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_event.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final SaveAddressUsecase _saveAddressUsecase;
  final FetchAddressUsecase _fetchAddressUsecase;
  final RemoveAddressUsecase _removeAddressUsecase;
  final UpdateAddressUsecase _updateAddressUsecase;

  AddressBloc(
      this._saveAddressUsecase,
      this._getCurrentUserUsecase,
      this._fetchAddressUsecase,
      this._removeAddressUsecase,
      this._updateAddressUsecase,
      ) : super(const AddressState()) {
    on<LoadAddress>(_onLoadAddress);
    on<SaveAddressEvent>(_onSaveAddressEvent);
    on<FetchAddressesEvent>(_onFetchAddresses);
    on<RemoveAddressEvent>(_onRemoveAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<SelectAddressEvent>(_onSelectAddress);
  }

  Future<void> _onLoadAddress(LoadAddress event, Emitter<AddressState> emit) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final result = await _getCurrentUserUsecase.call(params: NoParams()).timeout(
        const Duration(seconds: 10),
        onTimeout: () => Left<Failure, UserModel>(ServerFailure('Hết thời gian tải dữ liệu')),
      );
      result.fold(
            (failure) => emit(state.copyWith(
          status: AddressStatus.failure,
          errorMessage: failure.message,
        )),
            (user) {
          emit(state.copyWith(status: AddressStatus.initial, user: user));
          add(FetchAddressesEvent(user.id)); // Tự động fetch địa chỉ sau khi lấy user
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: AddressStatus.failure,
        errorMessage: 'Lỗi không xác định: $e',
      ));
    }
  }

  Future<void> _onSaveAddressEvent(SaveAddressEvent event, Emitter<AddressState> emit) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final params = SaveAddressParams(userId: event.userId, address: event.address);
      final result = await _saveAddressUsecase.call(params: params);
      result.fold(
            (failure) => emit(state.copyWith(
          status: AddressStatus.failure,
          errorMessage: failure.message,
        )),
            (_) => emit(state.copyWith(status: AddressStatus.success)),
      );
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.failure, errorMessage: '$e'));
    }
  }

  Future<void> _onFetchAddresses(FetchAddressesEvent event, Emitter<AddressState> emit) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      await for (final result in _fetchAddressUsecase.call(params: event.userId)) {
        result.fold(
              (failure) => emit(state.copyWith(
            status: AddressStatus.failure,
            errorMessage: failure.message,
          )),
              (addresses) => emit(state.copyWith(
            status: AddressStatus.success,
            addresses: addresses,
          )),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.failure, errorMessage: '$e'));
    }
  }

  Future<void> _onRemoveAddress(RemoveAddressEvent event, Emitter<AddressState> emit) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final remove = RemoveAddressParams(userId: event.params.userId, addressId: event.params.addressId);
    try {
      final result = await _removeAddressUsecase.call(params: remove);
      result.fold(
            (failure) => emit(state.copyWith(
          status: AddressStatus.failure,
          errorMessage: failure.message,
        )),
            (_) => emit(state.copyWith(status: AddressStatus.success)),
      );
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.failure, errorMessage: '$e'));
    }
  }

  Future<void> _onUpdateAddress(UpdateAddressEvent event, Emitter<AddressState> emit) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final update = UpdateAddressParams(
      userId: event.params.userId,
      address: event.params.address,
      addressId: event.params.addressId,
    );
    try {
      final result = await _updateAddressUsecase.call(params: update);
      result.fold(
            (failure) => emit(state.copyWith(
          status: AddressStatus.failure,
          errorMessage: failure.message,
        )),
            (_) => emit(state.copyWith(status: AddressStatus.success)),
      );
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.failure, errorMessage: '$e'));
    }
  }

  Future<void> _onSelectAddress(SelectAddressEvent event, Emitter<AddressState> emit) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      // Tìm địa chỉ được chọn
      final selectedAddress = state.addresses.firstWhere((addr) => addr.id == event.addressId);

      // Cập nhật tất cả địa chỉ: chỉ địa chỉ được chọn là true, các địa chỉ khác là false
      final updatedAddresses = state.addresses.map((addr) {
        final isSelected = addr.id == event.addressId;
        return addr.copyWith(selectedAddress: isSelected);
      }).toList();

      // Cập nhật Firestore cho địa chỉ được chọn
      final updateParams = UpdateAddressParams(
        userId: event.userId,
        addressId: event.addressId,
        address: selectedAddress.copyWith(selectedAddress: true),
      );
      final result = await _updateAddressUsecase.call(params: updateParams);

      result.fold(
            (failure) => emit(state.copyWith(
          status: AddressStatus.failure,
          errorMessage: failure.message,
        )),
            (_) => emit(state.copyWith(
          status: AddressStatus.success,
          addresses: updatedAddresses, // Cập nhật danh sách địa chỉ trong state
        )),
      );

      // Đồng bộ các địa chỉ khác về false (nếu cần đảm bảo chỉ 1 địa chỉ được chọn)
      for (var addr in state.addresses.where((addr) => addr.id != event.addressId)) {
        await _updateAddressUsecase.call(
          params: UpdateAddressParams(
            userId: event.userId,
            addressId: addr.id,
            address: addr.copyWith(selectedAddress: false),
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.failure, errorMessage: '$e'));
    }
  }
}