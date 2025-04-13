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
    super.productAttributes,
    String? brandId,
  }) : super(
    brand: brandId != null
        ? BrandModel(id: brandId, name: '', image: '')
        : null,
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
      'brandId': brand?.id,
      'date': date?.millisecondsSinceEpoch, // Lưu dưới dạng int64 cho Typesense
      'salePrice': salePrice,
      'isFeatured': isFeatured,
      'categoryId': categoryId,
      'description': description,
      'images': images,
      'productAttributes':
      productAttributes?.map((attr) => attr.toJson()).toList(),
    }..removeWhere((key, value) => value == null); // Loại bỏ các field null
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return ProductModel.empty();
    return ProductModel(
      id: json['id']?.toString() ?? '', // Chuyển mọi giá trị thành String
      title: json['title'] as String? ?? '',
      stock: (json['stock'] as num?)?.toInt() ?? 0, // int32 từ Typesense
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // float từ Typesense
      thumbnail: json['thumbnail'] as String? ?? '',
      productType: json['productType'] as String? ?? '',
      sku: json['sku'] as String?,
      brandId: json['brandId'] as String?,
      date: json['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch((json['date'] as num).toInt())
          : null, // int64 từ Typesense
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      isFeatured: json['isFeatured'] as bool?,
      categoryId: json['categoryId'] as String?,
      description: json['description'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List<dynamic>)
          : null,
      productAttributes: json['productAttributes'] != null
          ? (json['productAttributes'] as List<dynamic>)
          .map((attr) => ProductAttributeModel.fromJson(attr as Map<String, dynamic>))
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
      title: data['title'] as String? ?? '',
      stock: (data['stock'] is String
          ? int.tryParse(data['stock'] as String)
          : data['stock'] as num?)?.toInt() ??
          0, // Xử lý cả String và num
      price: (data['price'] is String
          ? double.tryParse(data['price'] as String)
          : data['price'] as num?)?.toDouble() ??
          0.0, // Xử lý cả String và num
      thumbnail: data['thumbnail'] as String? ?? '',
      productType: data['productType'] as String? ?? '',
      sku: data['sku'] as String?,
      brandId: data['brandId'] as String?,
      date: data['date'] != null
          ? (data['date'] is String
          ? DateTime.parse(data['date'] as String)
          : (data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(
          (data['date'] as num).toInt())))
          : null, // Xử lý String, Timestamp, hoặc int
      salePrice: (data['salePrice'] is String
          ? double.tryParse(data['salePrice'] as String)
          : data['salePrice'] as num?)?.toDouble() ??
          0.0,
      isFeatured: data['isFeatured'] as bool?,
      categoryId: data['categoryId'] as String?,
      description: data['description'] as String?,
      images: data['images'] != null
          ? List<String>.from(data['images'] as List<dynamic>)
          : null,
      productAttributes: data['productAttributes'] != null
          ? (data['productAttributes'] as List<dynamic>)
          .map((attr) => ProductAttributeModel.fromJson(attr as Map<String, dynamic>))
          .toList()
          : null,
    );
  }
}