// lib/features/store/data/models/payment_method_model.dart
import 'package:mobile_sim_shop/features/store/domain/entities/payment_method.dart';

class PaymentMethodModel extends PaymentMethod {
  PaymentMethodModel({required super.id, required super.name});

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}