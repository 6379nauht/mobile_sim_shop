import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String profilePicture;
  final SignupStatus status;
  final String? errorMessage;
  final bool isAcceptedTerms;
  final bool errorShown;
  final bool successShown;
  final bool emailSent;
  final UserModel? createdUser;

  const SignupState( {
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    this.email = '',
    this.phoneNumber = '',
    this.password = '',
    this.profilePicture = '',
    this.status = SignupStatus.initial,
    this.errorMessage,
    this.isAcceptedTerms = false,
    this.errorShown = false,
    this.emailSent = false,
    this.createdUser,
    this.successShown = false
  });

  SignupState copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phoneNumber,
    String? password,
    String? profilePicture,
    SignupStatus? status,
    String? errorMessage,
    bool? isAcceptedTerms,
    bool? errorShown,
    bool? successShown,
    bool? emailSent,
    UserModel? createdUser,
}) {
  return SignupState(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    username:username ?? this.username,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    password: password ?? this.password,
    profilePicture: profilePicture ?? this.profilePicture,
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    isAcceptedTerms: isAcceptedTerms ?? this.isAcceptedTerms,
    errorShown: errorShown ?? this.errorShown,
    emailSent: emailSent ?? this.emailSent,
    createdUser: createdUser ?? this.createdUser,
    successShown: successShown ?? this.successShown,
  );
}

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        username,
        email,
        phoneNumber,
        password,
        profilePicture,
        status,
        errorMessage,
        isAcceptedTerms,
        errorShown,
        emailSent,
        createdUser,
        successShown
      ];
}
