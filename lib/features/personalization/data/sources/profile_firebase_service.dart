import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/update_user_params.dart';
import 'imgur_data_source.dart';

abstract class ProfileFirebaseService {
  Future<Either<Failure, UserModel>> updateUser(UpdateUserParams param);
  Future<Either<Failure, void>> deleteAccount(String? password); // Đổi thành nullable
}

class ProfileFirebaseServiceImpl implements ProfileFirebaseService {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final ImgurDataSource imgurDataSource;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  ProfileFirebaseServiceImpl({
    required this.firestore,
    required this.firebaseAuth,
    required this.imgurDataSource,
  });

  @override
  Future<Either<Failure, UserModel>> updateUser(UpdateUserParams param) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return Left(ServerFailure('Không có người dùng nào đang đăng nhập'));
      }

      final uid = currentUser.uid;
      final currentUserDoc = await firestore.collection('users').doc(uid).get().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Hết thời gian lấy dữ liệu người dùng'),
      );
      final existingUser = currentUserDoc.exists ? UserModel.fromSnapshot(currentUserDoc) : null;

      String? profilePictureUrl;
      String? newDeleteHash;
      if (param.imageFile != null) {
        if (!param.imageFile!.existsSync()) {
          return Left(ServerFailure('Tệp ảnh không tồn tại'));
        }
        if (existingUser?.deleteHash != null) {
          await imgurDataSource.deleteImage(existingUser!.deleteHash!).timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException('Hết thời gian xóa ảnh cũ'),
          );
        }
        final uploadResult = await imgurDataSource.uploadImage(param.imageFile!);
        if (uploadResult['link'] == null) {
          return Left(ServerFailure('Không thể tải ảnh lên Imgur'));
        }
        profilePictureUrl = uploadResult['link'];
        newDeleteHash = uploadResult['deleteHash'];
      }

      final updateData = _prepareUpdateData(param.user, profilePictureUrl, newDeleteHash);
      if (updateData.isNotEmpty) {
        await firestore.collection('users').doc(uid).set(
          updateData,
          SetOptions(merge: true),
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Hết thời gian cập nhật Firestore'),
        );
      }

      return await _fetchUpdatedUser(uid);
    } on SocketException {
      return Left(ServerFailure('Không có kết nối mạng'));
    } on TimeoutException catch (e) {
      return Left(ServerFailure(e.message ?? 'Hết thời gian xử lý'));
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Lỗi Firestore: ${e.message}'));
    } on Exception catch (e) {
      print('Chi tiết lỗi trong updateUser: $e');
      return Left(ServerFailure('Đã xảy ra lỗi khi cập nhật thông tin: $e'));
    }
  }
  @override
  Future<Either<Failure, void>> deleteAccount(String? password) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(ServerFailure('Không có người dùng nào đang đăng nhập'));
      }

      // Kiểm tra phương thức đăng nhập
      final providerData = user.providerData;
      bool isGoogleSignIn = providerData.any((info) => info.providerId == 'google.com');

      // Xác thực lại người dùng
      if (isGoogleSignIn) {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return Left(ServerFailure('Đăng nhập Google bị hủy'));
        }
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await user.reauthenticateWithCredential(credential).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('Hết thời gian xác thực Google'),
        );
      } else {
        if (password == null || password.isEmpty) {
          return Left(ServerFailure('Vui lòng cung cấp mật khẩu để xác thực'));
        }
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Hết thời gian xác thực lại'),
        );
      }

      // Xóa dữ liệu Firestore
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()?['deleteHash'] != null) {
        await imgurDataSource.deleteImage(userDoc.data()!['deleteHash']).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Hết thời gian xóa ảnh Imgur'),
        );
      }
      await firestore.collection('users').doc(user.uid).delete().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Hết thời gian xóa dữ liệu Firestore'),
      );

      // Xóa tài khoản Authentication
      await user.delete().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Hết thời gian xóa tài khoản'),
      );
      // Đăng xuất Google Sign-In
      await _googleSignIn.signOut();
      return const Right(null);
    } on SocketException {
      return Left(ServerFailure('Không có kết nối mạng'));
    } on TimeoutException catch (e) {
      return Left(ServerFailure(e.message ?? 'Hết thời gian xử lý'));
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure('Lỗi xác thực: ${e.message}'));
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Lỗi Firestore: ${e.message}'));
    } on Exception catch (e) {
      print('Chi tiết lỗi trong deleteAccount: $e');
      return Left(ServerFailure('Đã xảy ra lỗi khi xóa tài khoản: $e'));
    }
  }

  Map<String, dynamic> _prepareUpdateData(
      UserModel user, String? profilePictureUrl, String? deleteHash) {
    final updateData = <String, dynamic>{};
    if (user.firstName.isNotEmpty) updateData['firstName'] = user.firstName;
    if (user.lastName.isNotEmpty) updateData['lastName'] = user.lastName;
    if (user.username.isNotEmpty) updateData['username'] = user.username;
    if (user.email.isNotEmpty) updateData['email'] = user.email;
    if (user.phoneNumber.isNotEmpty) updateData['phoneNumber'] = user.phoneNumber;
    if (profilePictureUrl != null) updateData['profilePicture'] = profilePictureUrl;
    if (deleteHash != null) updateData['deleteHash'] = deleteHash;
    if (user.gender != null && user.gender!.isNotEmpty) updateData['gender'] = user.gender;
    if (user.birthDate != null && user.birthDate!.isNotEmpty) updateData['birthDate'] = user.birthDate;
    return updateData;
  }

  Future<Either<Failure, UserModel>> _fetchUpdatedUser(String uid) async {
    try {
      final userDoc = await firestore.collection('users').doc(uid).get().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Hết thời gian lấy thông tin cập nhật'),
      );
      if (!userDoc.exists || userDoc.data() == null) {
        return Left(ServerFailure('Không tìm thấy thông tin người dùng'));
      }
      return Right(UserModel.fromSnapshot(userDoc));
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Lỗi Firestore: ${e.message}'));
    } on TimeoutException catch (e) {
      return Left(ServerFailure(e.message ?? 'Hết thời gian xử lý'));
    } catch (e) {
      print('Chi tiết lỗi khi lấy thông tin: $e');
      return Left(ServerFailure('Không thể tải thông tin người dùng: $e'));
    }
  }
}