import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/store/data/models/banner_model.dart';
import 'package:mobile_sim_shop/features/store/data/sources/banner_firebase_service.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/banner_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerFirebaseService _firebaseService = getIt<BannerFirebaseService>();
  @override
  Future<Either<Failure, List<BannerModel>>> getAllBanner() async {
    return await _firebaseService.getAllBanner();
  }
}
