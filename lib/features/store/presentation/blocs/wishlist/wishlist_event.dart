// lib/features/store/presentation/blocs/wishlist/wishlist_event.dart
import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable{
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {
  const LoadWishlist();
}

class AddToWishlist extends WishlistEvent {
  final String productId;
  const AddToWishlist(this.productId);
  @override
  List<Object?> get props => [productId];

}

class RemoveFromWishlist extends WishlistEvent {
  final String productId;
  const RemoveFromWishlist(this.productId);
  @override
  List<Object?> get props => [productId];
}