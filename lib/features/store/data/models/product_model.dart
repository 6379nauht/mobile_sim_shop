import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/product.dart';
import '../../data/models/brand_model.dart';
import '../../data/models/product_attribute_model.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.stock,
    required super.price,
    required super.thumbnail,
    required super.productType,
    super.sku,
    super.date,
    super.images,
    super.salePrice = 0.0,
    super.isFeatured,
    super.categoryId,
    super.description,
    super.productAttributes, // Nhúng productAttributes
    String? brandId, // Chỉ lưu brandId trong Firestore
  }) : super(
    brand: brandId != null ? BrandModel(id: brandId, name: '', image: '') : null,
    productVariations: null, // Không nhúng productVariations
  );

  static ProductModel empty() => ProductModel(
    id: '',
    title: '',
    stock: 0,
    price: 0.0,
    thumbnail: '',
    productType: '',
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'stock': stock,
      'price': price,
      'thumbnail': thumbnail,
      'productType': productType,
      'sku': sku,
      'brandId': brand?.id, // Chỉ lưu brandId
      'date': date?.toIso8601String(),
      'salePrice': salePrice,
      'isFeatured': isFeatured,
      'categoryId': categoryId,
      'description': description,
      'images': images,
      'productAttributes': productAttributes?.map((attr) => attr.toJson()).toList(),
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return ProductModel.empty();
    return ProductModel(
      id: json['id'] as String,
      title: json['title'] ?? '',
      stock: json['stock'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] ?? '',
      productType: json['productType'] ?? '',
      sku: json['sku'],
      brandId: json['brandId'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      isFeatured: json['isFeatured'],
      categoryId: json['categoryId'],
      description: json['description'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      productAttributes: json['productAttributes'] != null
          ? (json['productAttributes'] as List)
          .map((attr) => ProductAttributeModel.fromJson(attr))
          .toList()
          : null,
    );
  }

  factory ProductModel.fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    if (!snapshot.exists) return ProductModel.empty();
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null || data.isEmpty) return ProductModel.empty();
    return ProductModel(
      id: snapshot.id,
      title: data['title'] ?? '',
      stock: data['stock'] ?? 0,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      thumbnail: data['thumbnail'] ?? '',
      productType: data['productType'] ?? '',
      sku: data['sku'],
      brandId: data['brandId'],
      date: data['date'] != null
          ? (data['date'] is String
          ? DateTime.parse(data['date'])
          : (data['date'] as Timestamp).toDate())
          : null,
      salePrice: (data['salePrice'] as num?)?.toDouble() ?? 0.0,
      isFeatured: data['isFeatured'],
      categoryId: data['categoryId'],
      description: data['description'],
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      productAttributes: data['productAttributes'] != null
          ? (data['productAttributes'] as List)
          .map((attr) => ProductAttributeModel.fromJson(attr))
          .toList()
          : null,
    );
  }
}