import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/store/data/models/banner_model.dart';

abstract class BannerRepository {
  Future<Either<Failure, List<BannerModel>>> getAllBanner();
}