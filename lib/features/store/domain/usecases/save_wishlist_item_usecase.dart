import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/usecase/usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/wishlist_repository.dart';

import '../../../../core/dependency_injection/locator.dart';

class SaveWishlistItemUsecase extends UseCase<Either, String> {
  @override
  Future<Either> call({String? params})async {
    return await getIt<WishlistRepository>().saveWishlistItem(params!);
  }
}