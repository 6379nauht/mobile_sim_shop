// lib/features/store/presentation/blocs/cart/cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:mobile_sim_shop/features/store/data/models/cart_item_model.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/payment_method.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemModel> cartItems;
  final String? errorMessage;
  final PaymentMethod? selectedPaymentMethod;
  final String? shippingAddress;
  final String? shippingPhoneNumber;
  final String? userName;
  const CartState({
    this.status = CartStatus.initial,
    this.cartItems = const [],
    this.errorMessage,
    this.selectedPaymentMethod,
    this.shippingAddress = '',
    this.shippingPhoneNumber = '',
    this.userName = '',
  });

  CartState copyWith({
    CartStatus? status,
    List<CartItemModel>? cartItems,
    String? errorMessage,
    PaymentMethod? selectedPaymentMethod,
    String? shippingAddress,
    String? shippingPhoneNumber,
    String? userName
  }) {
    return CartState(
      status: status ?? this.status,
      cartItems: cartItems ?? this.cartItems,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingPhoneNumber: shippingPhoneNumber ?? this.shippingPhoneNumber,
      userName: userName ?? this.userName
    );
  }

  @override
  List<Object?> get props => [
        status,
        cartItems,
        errorMessage,
        selectedPaymentMethod,
        shippingAddress,
        shippingPhoneNumber,
        userName
      ];
}
