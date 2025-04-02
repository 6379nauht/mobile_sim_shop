import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/store/data/local_sources/wishlist_local_service.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalService _localService = getIt<WishlistLocalService>();
  @override
  Future<Either<Failure, List<String>>> getWishlist() async{
    return await _localService.getWishlist();
  }

  @override
  Future<Either<Failure, void>> removeWishlistItem(String productId) async{
    return await _localService.removeWishlistItem(productId);
  }

  @override
  Future<Either<Failure, void>> saveWishlistItem(String productId) async{
    return await _localService.saveWishlistItem(productId);
  }

}