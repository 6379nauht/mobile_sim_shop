import 'package:equatable/equatable.dart';

abstract class PasswordConfigurationEvent extends Equatable{
  const PasswordConfigurationEvent();
  @override
  List<Object> get props => [];
}

class EmailChanged extends PasswordConfigurationEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}
class ResetPasswordEvent extends PasswordConfigurationEvent {}
class MarkErrorAsShown extends PasswordConfigurationEvent{}
class ResetStateEvent extends PasswordConfigurationEvent { // Event mới
  const ResetStateEvent();
  @override
  List<Object> get props => [];
}