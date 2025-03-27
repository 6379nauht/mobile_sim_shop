import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/update_user_params.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/delete_account_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/domain/usecases/update_user_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile_event.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile_state.dart';
import 'package:dartz/dartz.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final UpdateUserUsecase _updateUserUsecase;
  final DeleteAccountUsecase _deleteAccountUsecase;
  ProfileBloc(this._getCurrentUserUsecase, this._updateUserUsecase,
      this._deleteAccountUsecase)
      : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final result =
          await _getCurrentUserUsecase.call(params: NoParams()).timeout(
                const Duration(seconds: 10),
                onTimeout: () => Left<Failure, UserModel>(
                    ServerFailure('Hết thời gian tải dữ liệu')),
              );
      result.fold(
        (failure) => emit(state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        )),
        (user) => emit(state.copyWith(
          status: ProfileStatus.initial,
          user: user,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: 'Lỗi không xác định: $e',
      ));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    print(
        'Nhận UpdateProfile: user=${event.user}, imageFile=${event.imageFile}');
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final result = await _updateUserUsecase(
        params: UpdateUserParams(user: event.user, imageFile: event.imageFile),
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () =>
            Left<Failure, UserModel>(ServerFailure('Hết thời gian cập nhật')),
      );
      print('Kết quả updateUser: $result');
      result.fold(
            (failure) => emit(state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        )),
            (updatedUser) {
          // Cập nhật state với dữ liệu mới nhất
          emit(state.copyWith(
            status: ProfileStatus.success,
            user: updatedUser,
          ));
          // Tải lại dữ liệu từ Firestore để đảm bảo đồng bộ
          add(LoadProfile());
        },
      );
    } catch (e) {
      print('Lỗi trong _onUpdateProfile: $e');
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: 'Lỗi không xác định: $e',
      ));
    }
  }

  Future<void> _onDeleteAccount(
      DeleteAccountEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _deleteAccountUsecase.call(params: event.password);
    result.fold(
        (failure) => emit(state.copyWith(
            status: ProfileStatus.failure, errorMessage: failure.message)),
        (user) {
          emit(state.copyWith(status: ProfileStatus.unauthenticated, user: user));
        });
  }
}
