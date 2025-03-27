import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product_attribute.dart';

class ProductAttributeModel extends ProductAttribute {
  ProductAttributeModel({
    super.name,
    super.values,
  });

  // Phương thức empty: Trả về một ProductAttributeModel rỗng
  static ProductAttributeModel empty() => ProductAttributeModel(
    name: '',
    values: [],
  );

  // Phương thức toJson: Chuyển ProductAttributeModel thành Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'values': values,
    };
  }

  // Factory fromJson: Tạo ProductAttributeModel từ Map<String, dynamic>
  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return ProductAttributeModel.empty();
    return ProductAttributeModel(
      name: json['name'] ?? '',
      values: json['values'] != null ? List<String>.from(json['values']) : [],
    );
  }

  // Factory fromSnapshot: Tạo ProductAttributeModel từ DocumentSnapshot
  factory ProductAttributeModel.fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    if (!snapshot.exists) return ProductAttributeModel.empty();
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null || data.isEmpty) return ProductAttributeModel.empty();
    return ProductAttributeModel(
      name: data['name'] ?? '',
      values: data['values'] != null ? List<String>.from(data['values']) : [],
    );
  }
}