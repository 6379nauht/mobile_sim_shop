import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/features/auth/data/models/save_email_model.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/save_remember_me_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signin_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signin_with_google_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signout_usecase.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_event.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_state.dart';

import '../../../../../core/usecase/no_params.dart';
import '../../../data/models/user_model.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final GetRememberMeUseCase _getRememberMeUseCase;
  final SaveRememberMeUseCase _saveRememberMeUseCase;
  final SigninUsecase _signinUsecase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final SignOutUsecase _signOutUsecase;
  final SignInWithGoogleUsecase _signInWithGoogleUsecase;

  SigninBloc(
      this._getRememberMeUseCase,
      this._saveRememberMeUseCase,
      this._signinUsecase,
      this._getCurrentUserUsecase,
      this._signOutUsecase,
      this._signInWithGoogleUsecase)
      : super(const SigninState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SigninSubmitted>(_onSigninSubmitted);
    on<LoadRememberMe>(_onLoadRememberMe);
    on<ToggleRememberMe>(_onToggleRememberMe);
    on<CheckStatusSignIn>(_onCheckStatusSignIn);
    on<MarkErrorAsShown>(_onMarkErrorAsShown);
    on<SignOutEvent>(_onSignOutEvent);
    on<SignInWithGoogle>(_onSignInWithGoogle);
  }
  FutureOr<void> _onMarkErrorAsShown(
      MarkErrorAsShown event, Emitter<SigninState> emit) {
    emit(state.copyWith(errorShow: true));
  }

  FutureOr<void> _onEmailChanged(
      EmailChanged event, Emitter<SigninState> emit) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  FutureOr<void> _onPasswordChanged(
      PasswordChanged event, Emitter<SigninState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSigninSubmitted(
    SigninSubmitted event,
    Emitter<SigninState> emit,
  ) async {
    // Kiểm tra dữ liệu đầu vào trước khi xử lý
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(state.copyWith(
          status: SigninStatus.failure,
          errorMessage: 'Vui lòng nhập email và mật khẩu',
          errorShow: false));
      return;
    }

    emit(state.copyWith(status: SigninStatus.loading));

    try {
      final user = UserModel.empty().copyWith(
        email: state.email,
        password: state.password,
      );

      // Thêm timeout để tránh treo
      final result = await _signinUsecase
          .call(params: user)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Hết thời gian chờ phản hồi từ máy chủ');
      });

      result.fold(
        (failure) => emit(state.copyWith(
            status: SigninStatus.failure,
            errorMessage: failure.message,
            errorShow: false)),
        (signinUser) {
          emit(state.copyWith(
            status: SigninStatus.authenticated,
            user: signinUser,
          ));
          if (state.value) {
            final saveEmailModel = SaveEmailModel(
              email: state.email,
              remember: state.value,
            );
            _saveRememberMeUseCase.call(params: saveEmailModel);
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: SigninStatus.failure,
        errorMessage: 'Đã xảy ra lỗi: $e',
      ));
    }
  }

  Future<void> _onLoadRememberMe(
      LoadRememberMe event, Emitter<SigninState> emit) async {
    try {
      final result = await _getRememberMeUseCase.call(params: NoParams());

      // Xử lý kết quả dựa trên kiểu Either
      result.fold((failure) {}, (data) {
        emit(state.copyWith(email: data.email, value: data.remember));
      });
    } catch (e) {
      ///print("Unexpected error: $e");
    }
  }

  Future<void> _onToggleRememberMe(
      ToggleRememberMe event, Emitter<SigninState> emit) async {
    // Cập nhật trạng thái Remember Me
    emit(state.copyWith(value: event.value));

    // Create SaveEmailModel object
    final saveEmailModel = SaveEmailModel(
      email: state.email,
      remember: event.value,
    );

    // Call UseCase with SaveEmailModel using Either pattern
    final result = await _saveRememberMeUseCase.call(params: saveEmailModel);

    result.fold((failure) {}, (_) {
      // Successfully toggled
      ///print("ToggleRememberMe => email: ${saveEmailModel.email}, remember: ${saveEmailModel.remember}");
    });
  }

  Future<void> _onCheckStatusSignIn(
      CheckStatusSignIn event, Emitter<SigninState> emit) async {
    emit(state.copyWith(status: SigninStatus.loading));
    // Kiểm tra trạng thái đăng nhập
    final result = await _getCurrentUserUsecase.call(params: NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: SigninStatus.unauthenticated,
      )),
      (user) => emit(state.copyWith(
        status: user != null
            ? SigninStatus.authenticated
            : SigninStatus.unauthenticated,
        user: user,
      )),
    );
  }

  Future<void> _onSignOutEvent(
      SignOutEvent event, Emitter<SigninState> emit) async {
    emit(state.copyWith(status: SigninStatus.loading));
    try {
      final result = await _signOutUsecase.call(params: NoParams());

      result.fold(
          (failure) => emit(state.copyWith(
              status: SigninStatus.failure,
              errorMessage: failure.message,
              errorShow: false)),
          (_) => emit(state.copyWith(
                status: SigninStatus.unauthenticated,
                user: null,
              )));
    } catch (e) {
      emit(state.copyWith(
        status: SigninStatus.failure,
        errorMessage: 'Đã xảy ra lỗi khi đăng xuất: $e',
        errorShow: false,
      ));
    }
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogle event, Emitter<SigninState> emit) async {
    emit(state.copyWith(status: SigninStatus.loading));
    try {
      final result = await _signInWithGoogleUsecase.call();
      result.fold(
        (failure) => emit(state.copyWith(
          status: SigninStatus.failure,
          errorMessage: failure.message,
          errorShow: false,
        )),
        (user) => emit(state.copyWith(
          status: SigninStatus.authenticated,
          user: user,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SigninStatus.failure,
        errorMessage: 'Đã xảy ra lỗi: $e',
        errorShow: false,
      ));
    }
  }
}
