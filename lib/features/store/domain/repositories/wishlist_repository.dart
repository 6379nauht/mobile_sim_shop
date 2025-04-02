import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';

abstract class WishlistRepository {
  Future<Either<Failure, void>> saveWishlistItem(String productId);
  Future<Either<Failure, void>> removeWishlistItem(String productId);
  Future<Either<Failure, List<String>>> getWishlist();
}