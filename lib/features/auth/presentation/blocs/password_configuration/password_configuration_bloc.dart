import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/password_configuration/password_configuration_event.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/password_configuration/password_configuration_state.dart';

class PasswordConfigurationBloc extends Bloc<PasswordConfigurationEvent, PasswordConfigurationState> {
  final ResetPasswordUsecase _resetPasswordUsecase;


  PasswordConfigurationBloc(this._resetPasswordUsecase) : super(const PasswordConfigurationState()) {
    on<EmailChanged>(_onEmailChanged);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<MarkErrorAsShown>(_onMarkErrorAsShown);
    on<ResetStateEvent>(_onResetStateEvent);

  }
  FutureOr<void> _onResetStateEvent(
      ResetStateEvent event, Emitter<PasswordConfigurationState> emit) {
    emit(const PasswordConfigurationState()); // Reset về trạng thái ban đầu
  }
  FutureOr<void> _onEmailChanged(
      EmailChanged event, Emitter<PasswordConfigurationState> emit) {
    emit(state.copyWith(
      email: event.email,
    ));
  }
  FutureOr<void> _onMarkErrorAsShown(MarkErrorAsShown event, Emitter<PasswordConfigurationState> emit) {
    emit(state.copyWith(
      errorShow: true
    ));
  }

  Future<void> _onResetPasswordEvent(ResetPasswordEvent event, Emitter<PasswordConfigurationState> emit) async{
    emit(state.copyWith(status: PasswordStatus.loading));
    // Gọi usecase để reset password
    final result = await _resetPasswordUsecase.call(params: state.email);

    // Xử lý kết quả
    result.fold(
          (failure) => emit(state.copyWith(
        status: PasswordStatus.failure,
        errorMessage: failure.message,
        errorShow: false,
      )),
          (_) => emit(state.copyWith(
        status: PasswordStatus.success,
        errorMessage: '',
        errorShow: false,
      )),
    );
  }

}