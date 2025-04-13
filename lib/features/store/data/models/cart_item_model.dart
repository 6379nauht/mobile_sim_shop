import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {// Thêm thuộc tính stock
  CartItemModel({
    required super.productId,
    required super.quantity,
    super.brandName,
    required super.image,
    super.price,
    super.selectedVariation,
    super.title,
    super.variationId,
    required super.stock, // Thêm stock vào constructor
  });

  static CartItemModel empty() => CartItemModel(
    productId: '',
    quantity: 0,
    brandName: '',
    image: '',
    price: 0.0,
    selectedVariation: null,
    title: '',
    variationId: '',
    stock: 0, // Giá trị mặc định
  );

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'brandName': brandName,
      'image': image,
      'price': price,
      'selectedVariation': selectedVariation,
      'title': title,
      'variationId': variationId,
      'stock': stock, // Thêm stock vào JSON
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return CartItemModel.empty();
    return CartItemModel(
      productId: data['productId'] ?? '',
      quantity: data['quantity'] ?? 0,
      brandName: data['brandName'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      selectedVariation: data['selectedVariation'],
      title: data['title'] ?? '',
      variationId: data['variationId'] ?? '',
      stock: data['stock'] ?? 0, // Lấy stock từ JSON
    );
  }
}