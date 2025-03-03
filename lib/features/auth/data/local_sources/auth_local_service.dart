import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../models/save_email_model.dart';

abstract class AuthLocalDataService {
  Future<Either<Failure, void>> saveRememberMe(SaveEmailModel remember);
  Future<Either<Failure, SaveEmailModel>>getRememberMe();
}

class AuthLocalDataServiceImpl implements AuthLocalDataService {
  final SharedPreferences prefs;

  AuthLocalDataServiceImpl(this.prefs);

  static const String keyRememberMe = "remember_me";
  static const String keyEmail = "saved_email";


  @override
  Future<Either<Failure, void>> saveRememberMe(SaveEmailModel remember) async {
    try {
      await prefs.setBool(keyRememberMe, remember.remember ?? false);

      if (remember.remember == true) { // Chỉ lưu khi remember là true
        await prefs.setString(keyEmail, remember.email ?? 'Email');
      } else {
        await prefs.remove(keyEmail);
      }
      return const Right(null); // Thành công
    } catch (e) {
      return Left(AuthFailure('Lưu dữ liệu thất bại: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, SaveEmailModel>> getRememberMe() async {
    try {
      final bool rememberMe = prefs.getBool(keyRememberMe) ?? false;
      final String email = prefs.getString(keyEmail) ?? 'Email';

      return Right(SaveEmailModel(
        remember: rememberMe,
        email: email,
      ));
    } catch (e) {
      return Left(AuthFailure('Lấy dữ liệu thất bại: ${e.toString()}'));
    }
  }
}