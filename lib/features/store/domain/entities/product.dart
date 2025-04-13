
import 'package:mobile_sim_shop/features/store/domain/entities/brand.dart';

import '../../data/models/product_attribute_model.dart';
import '../../data/models/product_variation_model.dart';

class Product {
  final String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrice;
  String thumbnail;
  bool? isFeatured;
  Brand? brand;
  String? description;
  String? categoryId;
  List<String>? images;
  String productType;
  List<ProductAttributeModel>? productAttributes;

  Product({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.sku,
    this.brand,
    this.date,
    this.images,
    this.salePrice = 0.0,
    this.isFeatured,
    this.categoryId,
    this.description,
    this.productAttributes,
});
}