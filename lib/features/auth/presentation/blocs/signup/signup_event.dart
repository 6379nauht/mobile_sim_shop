import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent(); // Constructor mặc định
  @override
  List<Object?> get props => [];
}

class FirstNameChanged extends SignupEvent {
  final String firstName;
  const FirstNameChanged(this.firstName);

  @override
  List<Object> get props => [firstName];
}

class LastNameChanged extends SignupEvent {
  final String lastName;
  const LastNameChanged(this.lastName);

  @override
  List<Object> get props => [lastName];
}

class UsernameChanged extends SignupEvent {
  final String username;
  const UsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class EmailChanged extends SignupEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class PhoneNumberChanged extends SignupEvent {
  final String phoneNumber;
  const PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class PasswordChanged extends SignupEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class ProfilePictureChanged extends SignupEvent {
  final String profilePicture;
  const ProfilePictureChanged(this.profilePicture);

  @override
  List<Object> get props => [profilePicture];
}

class TermsAndConditionsChanged extends SignupEvent {
  final bool isAcceptedTerms;
  const TermsAndConditionsChanged(this.isAcceptedTerms);

  @override
  List<Object> get props => [isAcceptedTerms];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}

class MarkErrorAsShown extends SignupEvent {}


class CancelVerification extends SignupEvent {
  const CancelVerification();
}

class CheckEmailVerification extends SignupEvent {
  const CheckEmailVerification();
}

class MarkSuccessShown extends SignupEvent {}
