import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/store/data/models/banner_model.dart';

import '../../../../core/dependency_injection/locator.dart';

abstract class BannerFirebaseService {
  Future<Either<Failure, List<BannerModel>>> getAllBanner();
}

class BannerFirebaseServiceImpl implements BannerFirebaseService {
  @override
  Future<Either<Failure, List<BannerModel>>> getAllBanner() async {
    try {
      final querySnapshot = await getIt<FirebaseFirestore>()
          .collection('banners')
          .where('active', isEqualTo: true)
          .get();

      final banners = querySnapshot.docs
          .map((doc) => BannerModel.fromSnapshot(doc))
          .toList();

      return Right(banners);
    } on FirebaseException catch (e) {
      return Left(ServerFailure('lỗi firebase firestore ${e.message}'));
    } on Exception catch (e) {
      // Xử lý lỗi chung
      return Left(ServerFailure('Đã xảy ra lỗi: $e'));
    }
  }
}
