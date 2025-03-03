import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/check_email_verification_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/signup_usecase.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signup/signup_event.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signup/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  //Usecase
  final SignupUseCase _signupUseCase;
  final DeleteUserUsecase _deleteUserUsecase;
  final CheckEmailVerifiedUsecase _checkEmailVerifiedUsecase;
  Timer? _emailVerificationTimer;


  SignupBloc(this._signupUseCase, this._deleteUserUsecase,
      this._checkEmailVerifiedUsecase)
      : super(const SignupState()) {
    on<FirstNameChanged>(_onFirstNameChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<UsernameChanged>(_onUsernameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<TermsAndConditionsChanged>(_onIsAcceptedTerms);
    on<MarkErrorAsShown>(_onMarkErrorAsShown);
    on<MarkSuccessShown>(_onMarkSuccessShown);
    on<CancelVerification>(_onCancelVerification);
    on<CheckEmailVerification>(_onCheckEmailVerification);
  }

  FutureOr<void>  _onFirstNameChanged(FirstNameChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(firstName: event.firstName, errorShown: true));
  }

  FutureOr<void>  _onLastNameChanged(LastNameChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(lastName: event.lastName, errorShown: true));
  }

  FutureOr<void>  _onUsernameChanged(UsernameChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(username: event.username, errorShown: true));
  }

  FutureOr<void> _onEmailChanged(EmailChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(email: event.email, errorShown: true));
  }

  FutureOr<void> _onPhoneNumberChanged(
      PhoneNumberChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(phoneNumber: event.phoneNumber, errorShown: true));
  }

  FutureOr<void> _onPasswordChanged(PasswordChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(password: event.password, errorShown: true));
  }

  FutureOr<void> _onIsAcceptedTerms(
      TermsAndConditionsChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(
        isAcceptedTerms: event.isAcceptedTerms, errorShown: true));
  }

  FutureOr<void> _onMarkErrorAsShown(MarkErrorAsShown event, Emitter<SignupState> emit) {
    emit(state.copyWith(errorShown: true));
  }

  FutureOr<void> _onMarkSuccessShown(MarkSuccessShown event, Emitter<SignupState> emit) {
    emit(state.copyWith(successShown: true));
  }

  ///Submit
  Future<void> _onSignupSubmitted(
      SignupSubmitted event, Emitter<SignupState> emit) async {
    emit(state.copyWith(status: SignupStatus.loading));

    ///check accepted and terms
    if (!state.isAcceptedTerms) {
      emit(state.copyWith(
          status: SignupStatus.failure,
          errorMessage: "Bạn phải chấp nhận Chính sách quyền riêng tư & Điều khoản sử dụng.",
          errorShown: false));
      return;
    }

    if (_isFormInvalid()) {
      emit(state.copyWith(
          status: SignupStatus.failure,
          errorMessage: "Dữ liệu nhập không hợp lệ!",
          errorShown: false));
      return;
    }

    // Tạo user
    final user = UserModel(
      id: '',
      firstName: state.firstName,
      lastName: state.lastName,
      username: state.username,
      email: state.email,
      phoneNumber: state.phoneNumber,
      profilePicture: state.profilePicture,
      password: state.password,
    );

    try {
      final result = await _signupUseCase.call(params: user).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException(
              "Quá trình đăng ký mất quá nhiều thời gian. Vui lòng thử lại."));

      result.fold(
            (failure) {
          emit(state.copyWith(
              status: SignupStatus.failure,
              errorMessage: failure.message,
              errorShown: false));
        },
            (createdUser) {
          emit(state.copyWith(
            status: SignupStatus.success,
            createdUser: createdUser,
            emailSent: true,
            successShown: false
          ));

          //  Bắt đầu kiểm tra email xác minh mỗi 1 giây
          _startEmailVerificationCheck();
        },
      );
    } on TimeoutException catch (e) {
      emit(state.copyWith(
          status: SignupStatus.failure,
          errorMessage: e.message,
          errorShown: false));
    }
  }

  // Hàm bắt đầu kiểm tra email xác minh
  FutureOr<void> _startEmailVerificationCheck() {
    _emailVerificationTimer?.cancel(); // Đảm bảo không có Timer cũ đang chạy
    _emailVerificationTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      add(const CheckEmailVerification()); // Gửi event để kiểm tra trạng thái xác minh
    });
  }

  // 🚀 Khi nhận event kiểm tra email xác minh
  Future<void> _onCheckEmailVerification(
      CheckEmailVerification event, Emitter<SignupState> emit) async {
    try {
      final result = await _checkEmailVerifiedUsecase.call(params: NoParams());

      result.fold(
            (failure) {
          emit(state.copyWith(
            status: SignupStatus.failure,
            errorMessage: failure.message,
          ));
        },
            (_) {
          _emailVerificationTimer?.cancel(); //  Nếu xác minh thành công, dừng Timer
          emit(state.copyWith(status: SignupStatus.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          status: SignupStatus.failure,
          errorMessage: "Có lỗi xảy ra: ${e.toString()}"));
    }
  }

  ///cancel verify
  Future<void> _onCancelVerification(
      CancelVerification event, Emitter<SignupState> emit) async {
    _emailVerificationTimer?.cancel(); //  Dừng Timer khi người dùng hủy xác minh

    if (state.createdUser != null) {
      emit(state.copyWith(status: SignupStatus.loading));
      try {
        final result = await _deleteUserUsecase.call(params: state.createdUser);
        result.fold(
              (failure) => emit(const SignupState(status: SignupStatus.initial)),
              (_) => emit(const SignupState(status: SignupStatus.initial)),
        );
      } catch (e) {
        // Đảm bảo dừng loading khi có lỗi
        emit(const SignupState(status: SignupStatus.initial));
      }
    } else {
      // Để đảm bảo trạng thái được reset ngay cả khi không có người dùng
      emit(const SignupState(status: SignupStatus.initial));
    }
  }


  ///Cancel timer
  @override
  Future<void> close() {
    _emailVerificationTimer?.cancel(); // Dừng Timer khi đóng Bloc
    return super.close();
  }

  bool _isFormInvalid() {
    return state.firstName.isEmpty ||
        state.lastName.isEmpty ||
        state.email.isEmpty ||
        state.username.isEmpty ||
        state.phoneNumber.isEmpty ||
        state.password.isEmpty;
  }
}