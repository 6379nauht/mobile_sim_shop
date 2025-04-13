// lib/features/store/presentation/blocs/wishlist/wishlist_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_wishlist_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/remove_wishlist_item_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/save_wishlist_item_usecase.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishListUsecase _getWishListUsecase;
  final RemoveWishlistItemUsecase _removeWishlistItemUsecase;
  final SaveWishlistItemUsecase _saveWishlistItemUsecase;

  WishlistBloc(
      this._getWishListUsecase,
      this._removeWishlistItemUsecase,
      this._saveWishlistItemUsecase,
      ) : super(const WishlistState()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<AddToWishlist>(_onAddToWishlist);
    on<RemoveFromWishlist>(_onRemoveFromWishlist);
  }

  Future<void> _onLoadWishlist(
      LoadWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    emit(state.copyWith(status: WishlistStatus.loading));
    final result = await _getWishListUsecase.call(params: NoParams());
    result.fold(
          (failure) => emit(state.copyWith(
        status: WishlistStatus.failure,
        errorMessage: failure.message,
      )),
          (wishlist) => emit(state.copyWith(
        status: WishlistStatus.success,
        wishlist: wishlist,
      )),
    );
  }

  Future<void> _onAddToWishlist(
      AddToWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    // Cập nhật lạc quan: Thêm productId vào danh sách ngay lập tức
    final updatedWishlist = List<String>.from(state.wishlist)..add(event.productId);
    emit(state.copyWith(
      status: WishlistStatus.success, // Giữ trạng thái thành công
      wishlist: updatedWishlist,
    ));

    // Thực hiện lưu bất đồng bộ
    final result = await _saveWishlistItemUsecase.call(params: event.productId);
    result.fold(
          (failure) {
        // Nếu thất bại, hoàn tác cập nhật lạc quan
        final revertedWishlist = List<String>.from(updatedWishlist)..remove(event.productId);
        emit(state.copyWith(
          status: WishlistStatus.failure,
          wishlist: revertedWishlist,
          errorMessage: failure.message,
        ));
      },
          (_) {
      },
    );
  }

  Future<void> _onRemoveFromWishlist(
      RemoveFromWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    // Cập nhật lạc quan: Xóa productId khỏi danh sách ngay lập tức
    final updatedWishlist = List<String>.from(state.wishlist)..remove(event.productId);
    emit(state.copyWith(
      status: WishlistStatus.success, // Giữ trạng thái thành công
      wishlist: updatedWishlist,
    ));

    // Thực hiện xóa bất đồng bộ
    final result = await _removeWishlistItemUsecase.call(params: event.productId);
    result.fold(
          (failure) {
        // Nếu thất bại, hoàn tác cập nhật lạc quan
        final revertedWishlist = List<String>.from(updatedWishlist)..add(event.productId);
        emit(state.copyWith(
          status: WishlistStatus.failure,
          wishlist: revertedWishlist,
          errorMessage: failure.message,
        ));
      },
          (_) {
        // Thành công: Không cần làm gì thêm vì cập nhật lạc quan đã đúng
        // Tùy chọn: Lấy lại danh sách để đồng bộ (có thể bỏ qua)
      },
    );
  }
}