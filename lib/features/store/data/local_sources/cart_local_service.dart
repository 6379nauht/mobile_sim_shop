import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/store/data/models/cart_item_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/remove_cart_item.dart';
import 'package:mobile_sim_shop/features/store/data/models/update_quantity_params.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/payment_method.dart';
import '../models/create_payment_intent_params.dart';
import '../models/payment_method_model.dart';

abstract class CartLocalService {
  Future<Either<Failure, List<CartItemModel>>> getCartItem();
  Future<Either<Failure, void>> addToCart(CartItemModel item);
  Future<Either<Failure, void>> updateQuantity(UpdateQuantityParams params);
  Future<Either<Failure, void>> removeCartItem(RemoveCartItemParams params);
  Future<Either<Failure, void>> clearCart();
  Future<Either<Failure, void>> selectPaymentMethod(PaymentMethod paymentMethod);
  Future<Either<Failure, String>> createPaymentIntent(CreatePaymentIntentParams params);
  Future<Either<Failure, PaymentMethod>> fetchPaymentMethod();
}

class CartLocalServiceImpl implements CartLocalService {
  final SharedPreferences prefs;

  CartLocalServiceImpl(this.prefs);

  static const String _cartKey = 'cart';
  static const String _paymentMethodId = 'payment_method_id';
  static const String _paymentMethodName = 'payment_method_name';

  @override
  Future<Either<Failure, List<CartItemModel>>> getCartItem() async {
    try {
      final cartString = prefs.getString(_cartKey);
      if (cartString == null || cartString.isEmpty) {
        return const Right([]); // Trả về danh sách rỗng nếu không có dữ liệu
      }

      final List<dynamic> cartJson = json.decode(cartString);
      final cartItems = cartJson.map((json) => CartItemModel.fromJson(json)).toList();
      return Right(cartItems);
    } catch (e) {
      return Left(ServerFailure('Không thể tải dữ liệu giỏ hàng: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItemModel item) async {
    try {
      final currentItemsResult = await getCartItem();
      return currentItemsResult.fold(
            (failure) => Left(failure),
            (currentItems) async {
          final existingItemIndex = currentItems.indexWhere(
                (i) =>
            i.productId == item.productId &&
                i.selectedVariation.toString() == item.selectedVariation.toString(),
          );

          List<CartItemModel> updatedItems = List.from(currentItems);
          if (existingItemIndex >= 0) {
            updatedItems[existingItemIndex] = CartItemModel(
              productId: item.productId,
              quantity: updatedItems[existingItemIndex].quantity + item.quantity,
              brandName: item.brandName,
              image: item.image,
              price: item.price,
              selectedVariation: item.selectedVariation,
              title: item.title,
              variationId: item.variationId,
              stock: item.stock,
            );
          } else {
            updatedItems.add(item);
          }

          final cartJson = updatedItems.map((item) => item.toJson()).toList();
          await prefs.setString(_cartKey, json.encode(cartJson));
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Không thể thêm vào giỏ hàng: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(UpdateQuantityParams params) async {
    try {
      final currentItemsResult = await getCartItem();
      return currentItemsResult.fold(
            (failure) => Left(failure),
            (currentItems) async {
          final updatedItems = currentItems.map((item) {
            if (item.productId == params.productId) {
              return CartItemModel(
                productId: item.productId,
                quantity: params.quantity,
                brandName: item.brandName,
                image: item.image,
                price: item.price,
                selectedVariation: item.selectedVariation,
                title: item.title,
                variationId: item.variationId,
                stock: item.stock,
              );
            }
            return item;
          }).where((item) => item.quantity > 0).toList();

          final cartJson = updatedItems.map((item) => item.toJson()).toList();
          await prefs.setString(_cartKey, json.encode(cartJson));
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Không thể cập nhật số lượng: $e'));
    }
  }

  // Thêm phương thức xóa từng item
  @override
  Future<Either<Failure, void>> removeCartItem(RemoveCartItemParams params) async {
    try {
      final currentItemsResult = await getCartItem();
      return currentItemsResult.fold(
            (failure) => Left(failure),
            (currentItems) async {
          // Lọc bỏ item cần xóa dựa trên productId và variationId (nếu có)
          final updatedItems = currentItems.where((item) {
            if (params.variationId != null) {
              return !(item.productId == params.productId && item.variationId == params.variationId);
            }
            return item.productId != params.productId;
          }).toList();

          // Lưu lại danh sách đã cập nhật
          final cartJson = updatedItems.map((item) => item.toJson()).toList();
          await prefs.setString(_cartKey, json.encode(cartJson));
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Không thể xóa sản phẩm khỏi giỏ hàng: $e'));
    }
  }

  // Thêm phương thức xóa toàn bộ giỏ hàng
  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      // Xóa key cart khỏi SharedPreferences
      await prefs.remove(_cartKey);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Không thể xóa toàn bộ giỏ hàng: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> createPaymentIntent(CreatePaymentIntentParams params) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.2.1:3000/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'amount': params.amount, 'currency': params.currency}),
      );
      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        if(data['clientSecret'] != null) {
          return Right(data['clientSecret']);
        } else {
          return Left(ServerFailure('Không tìm thấy clientSecret'));
        }
      } else {
        return Left(ServerFailure('Tạo payment intent thất bại ${response.body}'));
      }
    } catch (e) {
      return Left(ServerFailure('Lỗi khi gọi API tạo payment intent: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> selectPaymentMethod(PaymentMethod paymentMethod) async {
    try {
      await prefs.setString(_paymentMethodId, paymentMethod.id);
      await prefs.setString(_paymentMethodName, paymentMethod.name);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error saving payment method: $e'));
      // Optionally: throw or handle the error in UI
    }
  }

  @override
  Future<Either<Failure, PaymentMethod>> fetchPaymentMethod() async {
    try {
      final paymentMethodId = prefs.getString(_paymentMethodId);
      final paymentMethodName = prefs.getString(_paymentMethodName);

      if (paymentMethodId == null || paymentMethodName == null) {
        return Left(ServerFailure('No payment method found in storage'));
      }

      final paymentMethod = PaymentMethod(
        id: paymentMethodId,
        name: paymentMethodName,
      );
      return Right(paymentMethod);
    } catch (e) {
      return Left(ServerFailure('Error fetching payment method: $e'));
    }
  }
}