import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/store/data/local_sources/cart_local_service.dart';
import 'package:mobile_sim_shop/features/store/data/models/cart_item_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/create_payment_intent_params.dart';
import 'package:mobile_sim_shop/features/store/data/models/payment_method_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/remove_cart_item.dart';
import 'package:mobile_sim_shop/features/store/data/models/update_quantity_params.dart';
import 'package:mobile_sim_shop/features/store/data/sources/cart_firebase_servive.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/invoice.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/cart_repository.dart';

import '../../../../core/dependency_injection/locator.dart';
import '../../domain/entities/payment_method.dart';
import '../models/send_order_confirmation_email_params.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalService _localService = getIt<CartLocalService>();
  final CartFirebaseService _firebaseService = getIt<CartFirebaseService>();

  @override
  Future<Either<Failure, void>> addToCart(CartItemModel item) async {
    return await _localService.addToCart(item);
  }

  @override
  Future<Either<Failure, List<CartItemModel>>> getCartItem() async{
    return await _localService.getCartItem();
  }

  @override
  Future<Either<Failure, void>> updateQuantity(UpdateQuantityParams params) async{
    return await _localService.updateQuantity(params);
  }

  @override
  Future<Either<Failure, void>> clearCart() async{
    return await _localService.clearCart();
  }

  @override
  Future<Either<Failure, void>> removeCartItem(RemoveCartItemParams params) async{
    return await _localService.removeCartItem(params);
  }

  @override
  Future<Either<Failure, void>> selectPaymentMethod(PaymentMethod paymentMethod) async{
    return await _localService.selectPaymentMethod(paymentMethod);
  }

  @override
  Future<Either<Failure, String>> createPaymentIntent(CreatePaymentIntentParams params) async {
    return await _localService.createPaymentIntent(params);
  }

  @override
  Future<Either<Failure, void>> createInvoice(Invoice invoice) async{
    return await _firebaseService.createInvoice(invoice);
  }

  @override
  Future<Either<Failure, PaymentMethod>> fetchPaymentMethod() async {
    return await _localService.fetchPaymentMethod();
  }

  @override
  Future<Either<Failure, void>> sendOrderConfirmationEmail(SendOrderConfirmationEmailParams params) {
    // TODO: implement sendOrderConfirmationEmail
    throw UnimplementedError();
  }
}