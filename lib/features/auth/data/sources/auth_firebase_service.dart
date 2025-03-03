import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart'; // Thêm Failure vào
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';

import '../../../../core/errors/failures.dart';

abstract class AuthFirebaseService {
  Future<Either<Failure, UserModel>> signup(UserModel user);
  Future<Either<Failure, void>> checkEmailVerified();
  Future<Either<Failure, void>> deleteUser(UserModel user);
  Future<Either<Failure, UserModel>> signin(UserModel user);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either<Failure, UserModel>> signup(UserModel user) async {
    try {
      UserCredential userCredential = await getIt<FirebaseAuth>()
          .createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      // Gửi email xác minh
      await userCredential.user?.sendEmailVerification();

      //Lưu vào firestore
      await getIt<FirebaseFirestore>()
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(user.toJson());

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Đăng ký thất bại'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  ///check email verify
  @override
  Future<Either<Failure, void>> checkEmailVerified() async {
    try {
      final firebaseUser = getIt<FirebaseAuth>().currentUser;
      await firebaseUser?.reload();
      if (firebaseUser?.emailVerified == true) {
        return const Right(null); // Email đã được xác minh
      } else {
        return Left(
            AuthFailure("Hãy kiểm tra email và xác nhận tài khoản của bạn."));
      }
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  ///deleteUser when cancel verify
  @override
  Future<Either<Failure, void>> deleteUser(UserModel user) async {
    try {
      final userId = getIt<FirebaseAuth>().currentUser?.uid;
      await getIt<FirebaseFirestore>()
          .collection('users')
          .doc(userId)
          .delete();
      await getIt<FirebaseAuth>().currentUser?.delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  //Signin
  @override
  Future<Either<Failure, UserModel>> signin(UserModel user) async {
    try {
      UserCredential userCredential = await getIt<FirebaseAuth>()
          .signInWithEmailAndPassword(
          email: user.email, password: user.password);

      DocumentSnapshot userDoc = await getIt<FirebaseFirestore>().collection(
          "users").doc(userCredential.user!.uid).get();

      //check user in firestore
      if (!userDoc.exists || userDoc.data() == null) {
        Left(AuthFailure("Tài khoản không tồn tại trong hệ thống!"));
      }

      UserModel signinUser = UserModel.fromSnapshot(
          userDoc.data() as DocumentSnapshot<Map<String, dynamic>>);

      return Right(signinUser);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return Left(AuthFailure("Tài khoản không tồn tại!"));
        case 'wrong-password':
          return Left(AuthFailure("Mật khẩu không chính xác!"));
        case 'invalid-email':
          return Left(AuthFailure("Email không hợp lệ!"));
        case 'user-disabled':
          return Left(AuthFailure("Tài khoản đã bị vô hiệu hóa!"));
        default:
          return Left(AuthFailure("Đăng nhập thất bại: ${e.message}"));
      }
    } catch (e) {
      return Left(ServerFailure("Lỗi không xác định: $e"));
    }
  }
}
