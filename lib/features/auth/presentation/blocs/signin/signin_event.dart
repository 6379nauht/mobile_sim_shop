
import 'package:equatable/equatable.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();
  @override
  List<Object?> get props => [];
}

class EmailChanged extends SigninEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends SigninEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class SigninSubmitted extends SigninEvent {
  const SigninSubmitted();
}

class LoadRememberMe extends SigninEvent {}

class ToggleRememberMe extends SigninEvent {
  final bool value;
  const ToggleRememberMe(this.value);

  @override
  List<Object> get props => [value];
}