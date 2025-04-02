import 'package:equatable/equatable.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';

enum ProfileStatus {initial, loading, success, failure, needsImgurAuth, unauthenticated}

class ProfileState extends Equatable {
  final UserModel? user;
  final ProfileStatus status;
  final String? errorMessage;
  final String? verificationId;
  const ProfileState({
    this.user,
    this.status = ProfileStatus.initial,
    this.errorMessage,
    this.verificationId
});

  ProfileState copyWith ({
    UserModel? user,
    ProfileStatus? status,
    String? errorMessage,
    String? verificationId
}) {
    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationId: verificationId ?? this.verificationId
    );
  }


  @override
  List<Object?> get props => [user, status, errorMessage, verificationId];

}