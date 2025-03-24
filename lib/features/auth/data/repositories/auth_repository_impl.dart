import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/features/auth/data/local_sources/auth_local_service.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/auth/data/sources/auth_firebase_service.dart';
import 'package:mobile_sim_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import '../models/save_email_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseService _firebaseService = getIt<AuthFirebaseService>();
  final AuthLocalDataService _localService = getIt<AuthLocalDataService>();

  // Đăng ký tài khoản
  @override
  Future<Either<Failure, UserModel>> signup(UserModel user) async {
    return await _firebaseService.signup(user);
  }

  // Kiểm tra email đã xác minh chưa
  @override
  Future<Either<Failure, void>> checkEmailVerified() async {
    return await _firebaseService.checkEmailVerified();
  }

  // Xóa tài khoản
  @override
  Future<Either<Failure, void>> deleteUser(UserModel user) async {
    return await _firebaseService.deleteUser(user);
  }

  // Đăng nhập
  @override
  Future<Either<Failure, UserModel>> signin(UserModel user) async {
    try {
      final result = await _firebaseService.signin(user);
      return result.fold(
            (failure) => Left(failure),
            (signedInUser) async {
          // Lưu userId vào local storage khi đăng nhập thành công
          await _localService.saveUserId(signedInUser.id);
          return Right(signedInUser);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  // Lưu thông tin "Remember Me"
  @override
  Future<Either<Failure, void>> saveRememberMe(SaveEmailModel remember) async {
    return await _localService.saveRememberMe(remember);
  }

  // Lấy thông tin "Remember Me"
  @override
  Future<Either<Failure, SaveEmailModel>> getRememberMe() async {
    return await _localService.getRememberMe();
  }

  // Lấy thông tin user hiện tại
  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final localUserIdResult = await _localService.getUserId();
      return localUserIdResult.fold(
            (failure) => Left(failure),
            (localUserId) async {
          if (localUserId == null) return const Right(null);

          final remoteResult = await _firebaseService.getCurrentUser();
          return remoteResult.fold(
                (failure) => Left(failure),
                (user) => Right(user),
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  // Đăng xuất
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final result = await _firebaseService.signOut();
      return result.fold(
            (failure) => Left(failure),
            (_) async {
          // Xóa userId khi đăng xuất
          await _localService.clearUserId();
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    try {
      final result = await _firebaseService.signInWithGoogle();
      return result.fold(
            (failure) => Left(failure),
            (signedInUser) async {
          await _localService.saveUserId(signedInUser.id);
          return Right(signedInUser);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async{
    return await _firebaseService.resetPassword(email);
  }
}