import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/invoice.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/create_payment_intent_params.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/models/remove_cart_item.dart';
import '../../data/models/send_order_confirmation_email_params.dart';
import '../../data/models/update_quantity_params.dart';
import '../entities/payment_method.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemModel>>> getCartItem();
  Future<Either<Failure, void>> addToCart(CartItemModel item);
  Future<Either<Failure, void>> updateQuantity(UpdateQuantityParams params);
  Future<Either<Failure, void>> removeCartItem(RemoveCartItemParams params);
  Future<Either<Failure, void>> clearCart();
  Future<Either<Failure, void>> selectPaymentMethod(PaymentMethod paymentMethod);
  Future<Either<Failure, String>> createPaymentIntent(CreatePaymentIntentParams params);
  Future<Either<Failure, void>> createInvoice(Invoice invoice);
  Future<Either<Failure, PaymentMethod>> fetchPaymentMethod();
  Future<Either<Failure, void>> sendOrderConfirmationEmail(SendOrderConfirmationEmailParams params);
}