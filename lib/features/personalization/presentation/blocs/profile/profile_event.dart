import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../auth/data/models/user_model.dart';


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserModel user;
  final File? imageFile; // Thêm imageFile
  const UpdateProfile({required this.user, this.imageFile});

  @override
  List<Object?> get props => [user, imageFile];
}

class AuthenticateImgur extends ProfileEvent {
  const AuthenticateImgur();
}

class DeleteAccountEvent extends ProfileEvent {
  final String? password;
  const DeleteAccountEvent({this.password});
  @override
  List<Object?> get props => [password];
}
