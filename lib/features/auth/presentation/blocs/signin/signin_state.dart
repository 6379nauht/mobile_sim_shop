import 'package:equatable/equatable.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';

enum SigninStatus { initial, loading, authenticated, unauthenticated, failure }

class SigninState extends Equatable {
  final String email;
  final String password;
  final SigninStatus status;
  final bool value;
  final String? errorMessage;
  final bool errorShow;
  final UserModel? user;

  const SigninState({
    this.errorMessage,
    this.errorShow = false,
    this.email = '',
    this.password = '',
    this.status = SigninStatus.initial,
    this.value = false,
    this.user,
  });

  SigninState copyWith({
    String? email,
    String? password,
    SigninStatus? status,
    bool? value,
    String? errorMessage,
    bool? errorShow,
    UserModel? user,
  }) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      value: value ?? this.value,
      errorMessage: errorMessage ?? this.errorMessage, // Fixed: was using errorMessage instead of successMessage
      errorShow: errorShow ?? this.errorShow,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    status,
    value,
    errorMessage,
    errorShow,
    user,
  ];
}