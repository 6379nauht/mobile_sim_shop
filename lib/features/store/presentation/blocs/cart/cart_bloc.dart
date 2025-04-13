import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/cart_item_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/create_payment_intent_params.dart';
import 'package:mobile_sim_shop/features/store/data/models/fetch_variation_params.dart';
import 'package:mobile_sim_shop/features/store/data/models/get_variation_id_attributes_params.dart';
import 'package:mobile_sim_shop/features/store/data/models/send_order_confirmation_email_params.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/add_to_cart_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/create_invoice_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/create_payment_intent_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_brand_by_id_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_payment_method_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_variation_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_cart_item_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_variation_id_attributes_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/select_payment_method_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/send_order_confirmation_email_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/update_quantity_usecase.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_state.dart';
import '../../../../personalization/presentation/blocs/address/address_bloc.dart';
import '../../../../personalization/presentation/blocs/address/address_state.dart';
import '../../../data/models/product_variation_model.dart';
import '../../../data/models/remove_cart_item.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/usecases/clear_cart_usecase.dart';
import '../../../domain/usecases/remove_cart_item_usecase.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUsecase _addToCartUsecase;
  final GetCartItemUsecase _getCartItemUsecase;
  final UpdateQuantityUsecase _updateQuantityUsecase;
  final RemoveCartItemUsecase _removeCartItemUsecase;
  final ClearCartUsecase _clearCartUsecase;
  final GetVariationIdAttributesUsecase _attributesUsecase;
  final FetchVariationUsecase _fetchVariationUsecase;
  final FetchBrandByIdUsecase _fetchBrandByIdUsecase;
  final SelectPaymentMethodUsecase _selectPaymentMethodUsecase;
  final CreatePaymentIntentUsecase _createPaymentIntentUsecase;
  final CreateInvoiceUsecase _createInvoiceUsecase;
  final AddressBloc addressBloc;
  final FetchPaymentMethodUsecase _fetchPaymentMethodUsecase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;
  final SendOrderConfirmationEmailUsecase _emailUsecase;
  CartBloc(
      this._addToCartUsecase,
      this._getCartItemUsecase,
      this._updateQuantityUsecase,
      this._removeCartItemUsecase,
      this._clearCartUsecase,
      this._attributesUsecase,
      this._fetchVariationUsecase,
      this._fetchBrandByIdUsecase,
      this._selectPaymentMethodUsecase,
      this._createPaymentIntentUsecase,
      this._createInvoiceUsecase,
      this.addressBloc,
      this._fetchPaymentMethodUsecase,
      this._getCurrentUserUsecase,
      this._emailUsecase)
      : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddProductToCart>(_onAddProductToCart);
    on<UpdateProductQuantity>(_onUpdateProductQuantity);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<ClearCart>(_onClearCart);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<ProcessPaymentEvent>(_onProcessPayment);
    on<ChangeShippingAddressEvent>(_onChangeShippingAddress);
    on<LoadPaymentMethod>(_onLoadPaymentMethod);
    // Lắng nghe AddressBloc để đồng bộ địa chỉ đã chọn
    addressBloc.stream.listen((addressState) {
      if (addressState.status == AddressStatus.success &&
          addressState.addresses.isNotEmpty) {
        final selectedAddress = addressState.addresses.firstWhere(
          (addr) => addr.selectedAddress,
          orElse: () => addressState.addresses.first,
        );
        add(ChangeShippingAddressEvent(selectedAddress.fullAddress,
            selectedAddress.phoneNumber, selectedAddress.name));
      }
    });
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    final result = await _getCartItemUsecase.call(params: NoParams());
    result.fold(
      (failure) => emit(
          state.copyWith(status: CartStatus.failure, errorMessage: failure)),
      (cartItems) => emit(
          state.copyWith(status: CartStatus.initial, cartItems: cartItems)),
    );
  }

  Future<void> _onLoadPaymentMethod(
      LoadPaymentMethod event, Emitter<CartState> emit) async {
    final result = await _fetchPaymentMethodUsecase.call(params: NoParams());
    result.fold(
        (failure) => emit(
            state.copyWith(status: CartStatus.failure, errorMessage: failure)),
        (paymentMethod) => emit(state.copyWith(
            status: CartStatus.initial, selectedPaymentMethod: paymentMethod)));
  }

  Future<void> _onAddProductToCart(
      AddProductToCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));

    // Kiểm tra nếu sản phẩm có thuộc tính (có biến thể)
    if (event.product.productAttributes != null &&
        event.product.productAttributes!.isNotEmpty) {
      // Lấy danh sách các thuộc tính bắt buộc
      final requiredAttributes =
          event.product.productAttributes!.map((attr) => attr.name).toSet();

      // Kiểm tra xem người dùng đã chọn đầy đủ các thuộc tính chưa
      if (!requiredAttributes
          .every((attr) => event.selectedVariations.containsKey(attr))) {
        emit(state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Vui lòng chọn đầy đủ các thuộc tính',
        ));
        return;
      }

      // Lấy variationId từ usecase
      final variationIdResult = await _attributesUsecase.call(
        params: GetVariationIdAttributesParams(
          productId: event.product.id,
          selectedVariations: event.selectedVariations,
        ),
      );

      late String? variationId;
      final isVariationIdValid = variationIdResult.fold(
        (failure) {
          emit(state.copyWith(
            status: CartStatus.failure,
            errorMessage: failure.message,
          ));
          return false;
        },
        (id) {
          variationId = id;
          return id != null; // Kiểm tra nếu variationId không null
        },
      );

      if (!isVariationIdValid) {
        emit(state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Biến thể không hợp lệ hoặc không tồn tại',
        ));
        return;
      }

      // Lấy thông tin chi tiết của biến thể
      final variationResult = await _fetchVariationUsecase.call(
        params: FetchVariationParams(
          productId: event.product.id,
          variationId: variationId!,
        ),
      );

      late ProductVariationModel selectedVariation;
      final isVariationValid = variationResult.fold(
        (failure) {
          emit(state.copyWith(
            status: CartStatus.failure,
            errorMessage: failure.message,
          ));
          return false;
        },
        (varModel) {
          selectedVariation = varModel;
          return true;
        },
      );

      if (!isVariationValid) return;

      // Kiểm tra tồn kho của biến thể
      if (selectedVariation.stock <= 0) {
        emit(state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Biến thể sản phẩm hiện tại hết hàng',
        ));
        return;
      }

      if (event.quantity > selectedVariation.stock) {
        emit(state.copyWith(
          status: CartStatus.failure,
          errorMessage:
              'Số lượng vượt quá tồn kho (${selectedVariation.stock})',
        ));
        return;
      }

      // Tính giá hiệu quả (giá bán hoặc giá gốc)
      final effectivePrice = selectedVariation.salePrice > 0
          ? selectedVariation.salePrice
          : selectedVariation.price;

      late BrandModel brand;
      final resultBrand =
          await _fetchBrandByIdUsecase.call(params: event.product.brand!.id);

      resultBrand.fold(
          (failure) => emit(state.copyWith(
              status: CartStatus.failure, errorMessage: failure)), (result) {
        brand = result;
      });

      // Tạo CartItem cho biến thể
      final cartItem = CartItemModel(
        productId: event.product.id,
        quantity: event.quantity,
        brandName: brand.name,
        image: event.product.thumbnail,
        price: effectivePrice,
        selectedVariation: event.selectedVariations,
        title: event.product.title,
        variationId: variationId!, // Sử dụng variationId đã xác nhận
        stock: selectedVariation.stock,
      );

      // Thêm vào giỏ hàng
      final result = await _addToCartUsecase.call(params: cartItem);
      await result.fold(
        (failure) async => emit(state.copyWith(
            status: CartStatus.failure, errorMessage: failure.message)),
        (_) async {
          final updateItem = await _getCartItemUsecase.call(params: NoParams());
          updateItem.fold(
            (failure) => emit(state.copyWith(
                status: CartStatus.failure, errorMessage: failure.message)),
            (cartItems) => emit(state.copyWith(
                status: CartStatus.success, cartItems: cartItems)),
          );
        },
      );
    }
  }

  Future<void> _onUpdateProductQuantity(
      UpdateProductQuantity event, Emitter<CartState> emit) async {
    // Lấy item hiện tại từ state, kiểm tra cả productId và variationId
    final currentItem = state.cartItems.firstWhere(
      (item) =>
          item.productId == event.params.productId &&
          item.variationId == event.variationId, // Thêm kiểm tra variationId
      orElse: () => CartItemModel.empty(),
    );

    if (currentItem.productId.isEmpty) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: 'Không tìm thấy sản phẩm trong giỏ hàng',
      ));
      return;
    }

    if (event.params.quantity > currentItem.stock) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: 'Số lượng vượt quá tồn kho (${currentItem.stock})',
      ));
      return;
    }

    final result = await _updateQuantityUsecase.call(params: event.params);
    result.fold(
      (failure) => emit(state.copyWith(
          status: CartStatus.failure, errorMessage: failure.message)),
      (_) {
        final updatedCartItems = state.cartItems.map((item) {
          if (item.productId == event.params.productId &&
              item.variationId == event.variationId) {
            // Thêm kiểm tra variationId
            return CartItemModel(
              productId: item.productId,
              quantity: event.params.quantity,
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
        }).toList();

        emit(state.copyWith(
            status: CartStatus.success, cartItems: updatedCartItems));
      },
    );
  }

  Future<void> _onRemoveCartItem(
      RemoveCartItem event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _removeCartItemUsecase.call(
      params: RemoveCartItemParams(
          productId: event.params.productId,
          variationId: event.params.variationId),
    );
    await result.fold(
      (failure) async => emit(state.copyWith(
          status: CartStatus.failure, errorMessage: failure.message)),
      (_) async {
        // Cập nhật danh sách giỏ hàng sau khi xóa
        final updatedCartItems = state.cartItems
            .where((item) => !(item.productId == event.params.productId &&
                item.variationId ==
                    event.params
                        .variationId)) // Lọc dựa trên cả productId và variationId
            .toList();
        emit(state.copyWith(
            status: CartStatus.success, cartItems: updatedCartItems));
      },
    );
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _clearCartUsecase.call(params: NoParams());
    await result.fold(
      (failure) async => emit(state.copyWith(
          status: CartStatus.failure, errorMessage: failure.message)),
      (_) async =>
          emit(state.copyWith(status: CartStatus.success, cartItems: [])),
    );
  }

  Future<void> _onSelectPaymentMethod(
      SelectPaymentMethodEvent event, Emitter<CartState> emit) async {
    try {
      await _selectPaymentMethodUsecase.call(params: event.paymentMethod);
      emit(state.copyWith(
        status: CartStatus.initial,
        selectedPaymentMethod: event.paymentMethod,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: 'Failed to select payment method $e',
      ));
    }
  }

  Future<void> _onProcessPayment(
      ProcessPaymentEvent event, Emitter<CartState> emit) async {
    try {
      // Kiểm tra phương thức thanh toán
      if (state.selectedPaymentMethod == null) {
        emit(state.copyWith(
            status: CartStatus.failure,
            errorMessage: 'Vui lòng chọn phương thức thanh toán'));
        return;
      }

      // Kiểm tra giỏ hàng
      if (state.cartItems.isEmpty) {
        emit(state.copyWith(
            status: CartStatus.failure,
            errorMessage: 'Giỏ hàng trống, không thể thanh toán'));
        return;
      }

      // Kiểm tra địa chỉ giao hàng
      if (state.shippingAddress == null || state.shippingPhoneNumber == null) {
        emit(state.copyWith(
            status: CartStatus.failure,
            errorMessage: 'Vui lòng chọn địa chỉ giao hàng'));
        return;
      }

      UserModel? user;
      final currentUser = await _getCurrentUserUsecase.call(params: NoParams());
      currentUser.fold(
          (failure) => emit(state.copyWith(
              status: CartStatus.failure, errorMessage: failure)),
          (userCurrent) => user = userCurrent);
      // Xử lý thanh toán với Stripe
      if (state.selectedPaymentMethod!.id == 'stripe') {
        final result = await _createPaymentIntentUsecase.call(
            params: CreatePaymentIntentParams(
                amount: event.amount, currency: 'vnd'));
        await result.fold(
          (failure) async => emit(state.copyWith(
              status: CartStatus.failure, errorMessage: failure.message)),
          (clientSecret) async {
            try {
              // Khởi tạo Payment Sheet
              await Stripe.instance.initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: clientSecret,
                  merchantDisplayName: 'CUA HANG AFE',
                ),
              );

              // Hiển thị Payment Sheet và chờ người dùng xác nhận
              await Stripe.instance.presentPaymentSheet();

              // Thanh toán thành công, tạo và lưu hóa đơn
              final invoice = Invoice(
                id: 'inv_${Random().nextInt(1000000)}',
                orderNumber:
                    '#${Random().nextInt(1000000).toString().padLeft(6, '0')}',
                totalAmount: event.amount,
                paymentMethodId: state.selectedPaymentMethod!.id,
                paymentMethodName: state.selectedPaymentMethod!.name,
                status: 'Đang xử lý',
                timestamp: DateTime.now(),
                deliveryDate: DateTime.now().add(const Duration(days: 2)),
                shippingAddress: state.shippingAddress!,
                shippingPhoneNumber: state.shippingPhoneNumber!,
                userName: state.userName,
                userId: user?.id,
                items: state.cartItems
                    .map((item) => {
                          'productId': item.productId,
                          'title': item.title,
                          'price': item.price,
                          'quantity': item.quantity,
                          'thumbnail': item.image,
                        })
                    .toList(),
              );

              final invoiceResult =
                  await _createInvoiceUsecase.call(params: invoice);
              await invoiceResult.fold(
                (failure) async => emit(state.copyWith(
                    status: CartStatus.failure, errorMessage: failure.message)),
                (_) async {
                  // Gửi email xác nhận
                  if (user?.email != null) {
                    final emailResult = await _emailUsecase.call(
                        params: SendOrderConfirmationEmailParams(
                            recipientEmail: user!.email, invoice: invoice));
                    emailResult.fold(
                      (failure) => emit(state.copyWith(
                          status: CartStatus.failure,
                          errorMessage: failure.message)),
                      (_) => null,
                    );
                  }

                  // Xóa giỏ hàng sau khi thanh toán thành công
                  add(ClearCart());
                  emit(state.copyWith(status: CartStatus.success));
                },
              );
            } on StripeException catch (e) {
              // Xử lý trường hợp hủy thanh toán
              if ((e.error.message?.toLowerCase().contains('cancel') ??
                  false)) {
                emit(state.copyWith(
                    status: CartStatus.initial,
                    errorMessage: 'Thanh toán đã bị hủy'));
              } else {
                // Xử lý các lỗi khác từ Stripe
                emit(state.copyWith(
                    status: CartStatus.failure,
                    errorMessage: 'Lỗi thanh toán: ${e.error.message}'));
              }
            }
          },
        );
      } else {
        // Thanh toán bằng COD (Cash on Delivery)
        final invoice = Invoice(
          id: 'inv_${Random().nextInt(1000000)}',
          orderNumber:
              '#${Random().nextInt(1000000).toString().padLeft(6, '0')}',
          totalAmount: event.amount,
          paymentMethodId: state.selectedPaymentMethod!.id,
          paymentMethodName: state.selectedPaymentMethod!.name,
          status: 'Đang xử lý',
          timestamp: DateTime.now(),
          deliveryDate: DateTime.now().add(const Duration(days: 2)),
          shippingAddress: state.shippingAddress!,
          shippingPhoneNumber: state.shippingPhoneNumber!,
          userName: state.userName,
          userId: user?.id,
          items: state.cartItems
              .map((item) => {
                    'productId': item.productId,
                    'title': item.title,
                    'price': item.price,
                    'quantity': item.quantity,
                    'thumbnail': item.image,
                  })
              .toList(),
        );

        final invoiceResult = await _createInvoiceUsecase.call(params: invoice);
        await invoiceResult.fold(
          (failure) async => emit(state.copyWith(
              status: CartStatus.failure, errorMessage: failure.message)),
          (_) async {
            // Gửi email xác nhận
            if (user?.email != null) {
              final emailResult = await _emailUsecase.call(
                  params: SendOrderConfirmationEmailParams(
                      recipientEmail: user!.email, invoice: invoice));
              emailResult.fold(
                (failure) => emit(state.copyWith(
                    status: CartStatus.failure, errorMessage: failure.message)),
                (_) => null,
              );
            }

            // Xóa giỏ hàng sau khi thanh toán thành công
            add(ClearCart());
            emit(state.copyWith(status: CartStatus.success));
          },
        );
      }
    } catch (e) {
      emit(state.copyWith(
          status: CartStatus.failure, errorMessage: 'Lỗi không xác định: $e'));
    }
  }

  FutureOr<void> _onChangeShippingAddress(
      ChangeShippingAddressEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(
        shippingAddress: event.shippingAddress,
        shippingPhoneNumber: event.shippingPhoneNumber,
        userName: event.userName));
  }
}
