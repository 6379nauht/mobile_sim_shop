import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/features/auth/data/models/save_email_model.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/save_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_event.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_state.dart';

import '../../../../../core/usecase/no_params.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final GetRememberMeUseCase _getRememberMeUseCase;
  final SaveRememberMeUseCase _saveRememberMeUseCase;

  SigninBloc(this._getRememberMeUseCase, this._saveRememberMeUseCase)
      : super(const SigninState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SigninSubmitted>(_onSigninSubmitted);
    on<LoadRememberMe>(_onLoadRememberMe);
    on<ToggleRememberMe>(_onToggleRememberMe);
  }

  FutureOr<void> _onEmailChanged(EmailChanged event,
      Emitter<SigninState> emit) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  FutureOr<void> _onPasswordChanged(PasswordChanged event,
      Emitter<SigninState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSigninSubmitted(SigninSubmitted event,
      Emitter<SigninState> emit) async {
    emit(state.copyWith(status: SigninStatus.loading));

    await Future.delayed(const Duration(seconds: 2)); // Giả lập gọi API

    // Giả lập đăng nhập thành công
    emit(state.copyWith(status: SigninStatus.success));

    // Nếu chọn Remember Me, lưu lại email và password
    if (state.value) {
      final saveEmailModel = SaveEmailModel(
        email: state.email,
        remember: state.value,
      );
      ///print("SubmitApp => email: ${saveEmailModel.email}, remember: ${saveEmailModel.remember}");

      await _saveRememberMeUseCase.call(
          params: saveEmailModel); // Truyền `params:`
    }
  }

  Future<void> _onLoadRememberMe(LoadRememberMe event,
      Emitter<SigninState> emit) async {
    try {
      final result = await _getRememberMeUseCase.call(params: NoParams());

      // Xử lý kết quả dựa trên kiểu Either
      result.fold(
              (failure) {
            // Xử lý trường hợp lỗi
            ///print("Error loading remember me data: $failure");
          },
              (data) {
            // Xử lý trường hợp thành công
            ///print("LoadApp => email: ${data.email}, remember: ${data.remember}");
            emit(state.copyWith(email: data.email, value: data.remember));
          }
      );
    } catch (e) {
      ///print("Unexpected error: $e");
    }
  }

  Future<void> _onToggleRememberMe(ToggleRememberMe event,
      Emitter<SigninState> emit) async {
    // Cập nhật trạng thái Remember Me
    emit(state.copyWith(value: event.value));

    // Create SaveEmailModel object
    final saveEmailModel = SaveEmailModel(
      email: state.email,
      remember: event.value,
    );

    // Call UseCase with SaveEmailModel using Either pattern
    final result = await _saveRememberMeUseCase.call(params: saveEmailModel);

    result.fold(
            (failure) {},
            (_) {
          // Successfully toggled
          ///print("ToggleRememberMe => email: ${saveEmailModel.email}, remember: ${saveEmailModel.remember}");
        }
    );
  }
}
