import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';

abstract class WishlistLocalService {
  Future<Either<Failure, void>> saveWishlistItem(String productId);
  Future<Either<Failure, void>> removeWishlistItem(String productId);
  Future<Either<Failure, List<String>>> getWishlist();
}
class WishlistLocalServiceImpl implements WishlistLocalService {
  final SharedPreferences prefs;

  WishlistLocalServiceImpl(this.prefs);

  static const String keyWishlist = 'wishlist';

  @override
  Future<Either<Failure, void>> saveWishlistItem(String productId) async {
    try {
      final wishlist = prefs.getStringList(keyWishlist) ?? [];
      if (!wishlist.contains(productId)) {
        wishlist.add(productId);
        await prefs.setStringList(keyWishlist, wishlist);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to save wishlist item: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeWishlistItem(String productId) async {
    try {
      final wishlist = prefs.getStringList(keyWishlist) ?? [];
      wishlist.remove(productId);
      await prefs.setStringList(keyWishlist, wishlist);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to remove wishlist item: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getWishlist() async {
    try {
      final wishlist = prefs.getStringList(keyWishlist) ?? [];
      return Right(wishlist);
    } catch (e) {
      return Left(ServerFailure('Failed to get wishlist: $e'));
    }
  }
  
}