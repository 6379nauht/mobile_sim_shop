
import 'package:equatable/equatable.dart';

enum SigninStatus {initial, loading, success, failure}

class SigninState extends Equatable{
  final String email;
  final String password;
  final SigninStatus status;
  final bool value;

  const SigninState ({
    this.email = '',
    this.password = '',
    this.status = SigninStatus.initial,
    this.value = false,
});

  SigninState copyWith ({
    String? email,
    String? password,
    SigninStatus? status,
    bool? value,
}) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      value: value ?? this.value,
    );
}


  @override
  // TODO: implement props
  List<Object?> get props => [
    email,
    password,
    status,
    value
  ];

}