import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/banner.dart';

class BannerModel extends Banner {
  BannerModel(
      {required super.imageUrl,
      required super.targetPage,
      required super.active});

  Map<String, dynamic> toJson() {
    return {'imageUrl': imageUrl, 'targetPage': targetPage, 'active': active};
  }

  factory BannerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BannerModel(
        imageUrl: data['imageUrl'] ?? '',
        targetPage: data['targetPage'] ?? '',
        active: data['active'] ?? false);
  }
}
