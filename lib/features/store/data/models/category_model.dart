import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel(
      {required super.id,
      required super.name,
      required super.image,
      required super.isFeatured,
      super.parentId});

  static CategoryModel empty() =>
      CategoryModel(id: '', name: '', image: '', isFeatured: false);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image' : image,
      'isFeatured' : isFeatured,
      'parentId' : parentId
    };
  }

  factory CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return CategoryModel(
        id: document.id,
        name: data['name'] as String? ?? '', // Ép kiểu String, mặc định ''
        image: data['image'] as String? ?? '', // Ép kiểu String, mặc định ''
        isFeatured: data['isFeatured'] as bool? ?? false, // Ép kiểu bool, mặc định false
        parentId: data['parentId'] as String?, // Giữ nguyên null nếu không có
      );
    } else {
      return CategoryModel.empty();
    }
  }
}
