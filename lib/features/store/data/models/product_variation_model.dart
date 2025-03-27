import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product_variation.dart';

class ProductVariationModel extends ProductVariation {
  ProductVariationModel({
    required super.id,
    required super.attributeValues,
    super.sku = '',
    super.image = '',
    super.description = '',
    super.price = 0.0,
    super.salePrice = 0.0,
    super.stock = 0,
    super.productId, // Khai báo trong constructor
  });

  static ProductVariationModel empty() => ProductVariationModel(
    id: '',
    attributeValues: {},
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'image': image,
      'description': description,
      'price': price,
      'salePrice': salePrice,
      'stock': stock,
      'attributeValues': attributeValues,
      'productId': productId, // Sử dụng giá trị thực tế thay vì null
    };
  }

  factory ProductVariationModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return ProductVariationModel.empty();
    return ProductVariationModel(
      id: json['id'] ?? '',
      sku: json['sku'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      attributeValues: json['attributeValues'] != null
          ? Map<String, String>.from(json['attributeValues'])
          : {},
      productId: json['productId'], // Xử lý productId
    );
  }

  factory ProductVariationModel.fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    if (!snapshot.exists) return ProductVariationModel.empty();
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null || data.isEmpty) return ProductVariationModel.empty();
    return ProductVariationModel(
      id: snapshot.id ,
      sku: data['sku'] ?? '',
      image: data['image'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (data['salePrice'] as num?)?.toDouble() ?? 0.0,
      stock: data['stock'] ?? 0,
      attributeValues: data['attributeValues'] != null
          ? Map<String, String>.from(data['attributeValues'])
          : {},
      productId: data['productId'], // Xử lý productId
    );
  }
}