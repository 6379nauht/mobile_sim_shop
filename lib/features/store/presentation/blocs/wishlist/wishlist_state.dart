// lib/features/store/presentation/blocs/wishlist/wishlist_state.dart
import 'package:equatable/equatable.dart';

enum WishlistStatus { initial, loading, success, failure }

class WishlistState extends Equatable {
  final WishlistStatus status;
  final List<String> wishlist; // List of product IDs
  final String? errorMessage;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.wishlist = const [],
    this.errorMessage,
  });

  WishlistState copyWith({
    WishlistStatus? status,
    List<String>? wishlist,
    String? errorMessage,
  }) {
    return WishlistState(
      status: status ?? this.status,
      wishlist: wishlist ?? this.wishlist,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, wishlist, errorMessage];
}