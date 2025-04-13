import 'package:equatable/equatable.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/remove_cart_item.dart';
import 'package:mobile_sim_shop/features/store/data/models/update_quantity_params.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/remove_cart_item_usecase.dart';

import '../../../domain/entities/payment_method.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddProductToCart extends CartEvent {
  final ProductModel product;
  final Map<String, String> selectedVariations;
  final int quantity;

  const AddProductToCart(
      {required this.quantity,
      required this.product,
      required this.selectedVariations});

  @override
  List<Object?> get props => [product, selectedVariations, quantity];
}

class UpdateProductQuantity extends CartEvent {
  final UpdateQuantityParams params;
  final String variationId;
  const UpdateProductQuantity( {required this.params, required this.variationId,});

  @override
  List<Object?> get props => [params];
}

class RemoveCartItem extends CartEvent {
  final RemoveCartItemParams params;
  const RemoveCartItem({required this.params});

  @override
  List<Object?> get props => [params];
}

class ClearCart extends CartEvent {}

class SelectPaymentMethodEvent extends CartEvent {
  final PaymentMethod paymentMethod;

  const SelectPaymentMethodEvent({required this.paymentMethod});

  @override
  List<Object> get props => [paymentMethod];
}

class ProcessPaymentEvent extends CartEvent {
  final double amount;
  const ProcessPaymentEvent({required this.amount});
  @override
  List<Object> get props => [amount];
}

class ChangeShippingAddressEvent extends CartEvent {
  final String shippingAddress;
  final String shippingPhoneNumber;
  final String userName;

  const ChangeShippingAddressEvent(this.shippingAddress,
      this.shippingPhoneNumber, this.userName);

  @override
  List<Object> get props => [shippingAddress, shippingPhoneNumber, userName];
}

class LoadPaymentMethod extends CartEvent {}