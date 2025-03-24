import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../models/save_email_model.dart';

abstract class AuthLocalDataService {
  Future<Either<Failure, void>> saveRememberMe(SaveEmailModel remember);
  Future<Either<Failure, SaveEmailModel>> getRememberMe();

  Future<Either<Failure, void>> saveUserId(String userId);
  Future<Either<Failure, String?>> getUserId();
  Future<Either<Failure, void>> clearUserId();
}

class AuthLocalDataServiceImpl implements AuthLocalDataService {
  final SharedPreferences prefs;

  AuthLocalDataServiceImpl(this.prefs);

  static const String keyRememberMe = "remember_me";
  static const String keyEmail = "saved_email";
  static const String keyUserId = "user_id";

  /// Lưu thông tin "Remember Me"
  @override
  Future<Either<Failure, void>> saveRememberMe(SaveEmailModel remember) async {
    try {
      await prefs.setBool(keyRememberMe, remember.remember ?? false);

      if (remember.remember == true) {
        await prefs.setString(keyEmail, remember.email ?? 'Email');
      } else {
        await prefs.remove(keyEmail);
      }
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Lưu dữ liệu thất bại: ${e.toString()}'));
    }
  }

  /// Lấy thông tin "Remember Me"
  @override
  Future<Either<Failure, SaveEmailModel>> getRememberMe() async {
    try {
      final bool rememberMe = prefs.getBool(keyRememberMe) ?? false;
      final String email = prefs.getString(keyEmail) ?? '';

      return Right(SaveEmailModel(
        remember: rememberMe,
        email: email,
      ));
    } catch (e) {
      return Left(AuthFailure('Lấy dữ liệu thất bại: ${e.toString()}'));
    }
  }

  /// Lưu User ID
  @override
  Future<Either<Failure, void>> saveUserId(String userId) async {
    try {
      await prefs.setString(keyUserId, userId);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Lưu user ID thất bại: ${e.toString()}'));
    }
  }

  /// Lấy User ID
  @override
  Future<Either<Failure, String?>> getUserId() async {
    try {
      final userId = prefs.getString(keyUserId);
      return Right(userId);
    } catch (e) {
      return Left(AuthFailure('Lấy user ID thất bại: ${e.toString()}'));
    }
  }

  /// Xóa User ID
  @override
  Future<Either<Failure, void>> clearUserId() async {
    try {
      await prefs.remove(keyUserId);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Xóa user ID thất bại: ${e.toString()}'));
    }
  }
}
