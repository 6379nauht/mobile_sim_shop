import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/brand.dart';

class BrandModel extends Brand {
  BrandModel({
    required super.id,
    required super.name,
    required super.image,
    super.isFeatured,
    super.productsCount,
  });

  static BrandModel empty() => BrandModel(id: '', name: '', image: '');

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'productsCount': productsCount,
      'isFeatured': isFeatured,
    };
  }

  factory BrandModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return BrandModel.empty();
    return BrandModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      isFeatured: data['isFeatured'],
      productsCount: data['productsCount'],
    );
  }

  factory BrandModel.fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    if (!snapshot.exists) return BrandModel.empty();
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null || data.isEmpty) return BrandModel.empty();
    return BrandModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      isFeatured: data['isFeatured'],
      productsCount: data['productsCount'],
    );
  }
}