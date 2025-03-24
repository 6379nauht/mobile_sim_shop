import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthFirebaseService {
  Future<Either<Failure, UserModel>> signup(UserModel user);
  Future<Either<Failure, void>> checkEmailVerified();
  Future<Either<Failure, void>> deleteUser(UserModel user);
  Future<Either<Failure, UserModel>> signin(UserModel user);
  Future<Either<Failure, UserModel?>> getCurrentUser();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserModel>> signInWithGoogle();
  Future<Either<Failure, void>> resetPassword(String email);
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Future<Either<Failure, UserModel>> signup(UserModel user) async {
    try {
      UserCredential userCredential = await getIt<FirebaseAuth>()
          .createUserWithEmailAndPassword(email: user.email, password: user.password);

      // Gửi email xác minh
      await userCredential.user?.sendEmailVerification();

      // Tạo UserModel với ID từ Firebase Auth
      final userWithId = user.copyWith(
        id: userCredential.user!.uid,
        emailVerified: false,
        phoneVerificationPending: false,
      );

      // Lưu vào Firestore
      await getIt<FirebaseFirestore>()
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(userWithId.toJson());

      return Right(userWithId);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Đăng ký thất bại'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> checkEmailVerified() async {
    try {
      final firebaseUser = getIt<FirebaseAuth>().currentUser;
      await firebaseUser?.reload();
      if (firebaseUser?.emailVerified == true) {
        // Cập nhật trạng thái emailVerified trong Firestore
        await getIt<FirebaseFirestore>()
            .collection('users')
            .doc(firebaseUser!.uid)
            .update({'emailVerified': true});
        return const Right(null);
      } else {
        return Left(AuthFailure("Hãy kiểm tra email và xác nhận tài khoản của bạn."));
      }
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(UserModel user) async {
    try {
      final userId = getIt<FirebaseAuth>().currentUser?.uid;
      if (userId == null || userId != user.id) {
        return Left(AuthFailure('Không có quyền xóa tài khoản này'));
      }
      await getIt<FirebaseFirestore>().collection('users').doc(userId).delete();
      await getIt<FirebaseAuth>().currentUser?.delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signin(UserModel user) async {
    try {
      UserCredential userCredential = await getIt<FirebaseAuth>()
          .signInWithEmailAndPassword(email: user.email, password: user.password);

      DocumentSnapshot<Map<String, dynamic>> userDoc = await getIt<FirebaseFirestore>()
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        return Left(AuthFailure("Tài khoản không tồn tại trong hệ thống!"));
      }

      UserModel signinUser = UserModel.fromSnapshot(userDoc);
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

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final firebaseUser = getIt<FirebaseAuth>().currentUser;
      if (firebaseUser == null) return const Right(null);

      final userDoc = await getIt<FirebaseFirestore>()
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) return const Right(null);
      return Right(UserModel.fromSnapshot(userDoc));
    } catch (e) {
      return Left(ServerFailure("Lỗi không xác định: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _googleSignIn.signOut();
      await getIt<FirebaseAuth>().signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Lỗi không xác định: $e"));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    try {
      // Đăng xuất hoàn toàn trước để làm mới phiên
      final currentUser = getIt<FirebaseAuth>().currentUser;
      if (currentUser != null) {
        // Nếu đã đăng nhập, lấy dữ liệu hiện có
        final userDoc = await getIt<FirebaseFirestore>()
            .collection('users')
            .doc(currentUser.uid)
            .get()
            .timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Hết thời gian lấy dữ liệu người dùng'),
        );

        if (userDoc.exists && userDoc.data() != null) {
          print('Đã đăng nhập, trả về dữ liệu hiện có: ${currentUser.uid}');
          return Right(UserModel.fromSnapshot(userDoc));
        }
        // Nếu không có dữ liệu trong Firestore, tiếp tục tạo mới bên dưới
      }
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Left(AuthFailure('Đăng nhập bằng Google bị hủy'));
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await getIt<FirebaseAuth>().signInWithCredential(credential);

      final userDoc = await getIt<FirebaseFirestore>()
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      UserModel userModel;
      if (userDoc.exists && userDoc.data() != null) {
        userModel = UserModel.fromSnapshot(userDoc);
      } else {
        final displayName = userCredential.user!.displayName ?? '';
        final nameParts = UserModel.nameParts(displayName);
        final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lastName = nameParts.length > 1 ? nameParts[1] : '';

        userModel = UserModel(
          id: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          username: UserModel.generateUsername(displayName),
          email: userCredential.user!.email ?? '',
          phoneNumber: '',
          profilePicture: userCredential.user!.photoURL ?? '',
          password: '',
          emailVerified: userCredential.user!.emailVerified,
        );
        await getIt<FirebaseFirestore>()
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toJson());
      }

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Đăng nhập Google thất bại'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      if (email.isEmpty) {
        return Left(AuthFailure('Vui lòng nhập email'));
      }
      await getIt<FirebaseAuth>().sendPasswordResetEmail(email: email.trim());
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return Left(AuthFailure('Email không hợp lệ'));
        case 'user-not-found':
          return Left(AuthFailure('Không tìm thấy tài khoản với email này'));
        case 'too-many-requests':
          return Left(AuthFailure('Quá nhiều yêu cầu, vui lòng thử lại sau'));
        default:
          return Left(AuthFailure('Không thể gửi email đặt lại mật khẩu: ${e.message}'));
      }
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định: $e'));
    }
  }
}