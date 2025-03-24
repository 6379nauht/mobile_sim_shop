import 'package:equatable/equatable.dart';

enum PasswordStatus{ initial, loading, success, failure}

class PasswordConfigurationState extends Equatable {
  final String email;
  final PasswordStatus status;
  final String errorMessage;
  final bool errorShow;
  const PasswordConfigurationState({
   this.email = '',
    this.status = PasswordStatus.initial,
    this.errorMessage = '',
    this.errorShow = false,
});

  PasswordConfigurationState copyWith({
    String? email,
    PasswordStatus? status,
    String? errorMessage,
    bool? errorShow,
}) {
    return PasswordConfigurationState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      errorShow: errorShow ?? this.errorShow
    );
  }
  @override
  List<Object?> get props => [email, status, errorMessage, errorShow];

}