import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/invoice.dart';

class InvoiceModel extends Invoice {
  InvoiceModel({
    required super.id,
    required super.orderNumber,
    required super.totalAmount,
    required super.paymentMethodId,
    required super.paymentMethodName,
    required super.status,
    required super.timestamp,
    super.deliveryDate,
    required super.shippingAddress,
    super.userId,
    super.userName,
    required super.items,
    required super.shippingPhoneNumber,
  });

  // Hàm tạo rỗng
  static InvoiceModel empty() => InvoiceModel(
    id: '',
    orderNumber: '',
    totalAmount: 0.0,
    paymentMethodId: '',
    paymentMethodName: '',
    status: '',
    timestamp: DateTime.now(),
    deliveryDate: null,
    shippingAddress: '',
    shippingPhoneNumber: '',
    userId: null,
    userName: '',
    items: [],
  );

  // Chuyển đổi sang JSON để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'totalAmount': totalAmount,
      'paymentMethodId': paymentMethodId,
      'paymentMethodName': paymentMethodName,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'shippingAddress': shippingAddress,
      'shippingPhoneNumber' : shippingPhoneNumber,
      'userId': userId,
      'userName': userName,
      'items': items,
    }..removeWhere((key, value) => value == null); // Loại bỏ các trường null
  }

  // Tạo từ dữ liệu JSON (Firestore)
  factory InvoiceModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return InvoiceModel.empty();
    return InvoiceModel(
      id: data['id'] as String? ?? '',
      orderNumber: data['orderNumber'] as String? ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethodId: data['paymentMethodId'] as String? ?? '',
      paymentMethodName: data['paymentMethodName'] as String? ?? '',
      status: data['status'] as String? ?? '',
      timestamp: data['timestamp'] != null
          ? DateTime.parse(data['timestamp'] as String)
          : DateTime.now(),
      deliveryDate: data['deliveryDate'] != null
          ? DateTime.parse(data['deliveryDate'] as String)
          : null,
      shippingAddress: data['shippingAddress'] as String? ?? '',
      shippingPhoneNumber: data['shippingPhoneNumber'] as String? ?? '',
      userId: data['userId'] as String?,
      userName: data['userName'] as String?,
      items: data['items'] != null
          ? List<Map<String, dynamic>>.from(data['items'] as List<dynamic>)
          : [],
    );
  }

  // Tạo từ DocumentSnapshot (Firestore)
  factory InvoiceModel.fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    if (!snapshot.exists) return InvoiceModel.empty();
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null || data.isEmpty) return InvoiceModel.empty();

    return InvoiceModel(
      id: snapshot.id,
      orderNumber: data['orderNumber'] as String? ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethodId: data['paymentMethodId'] as String? ?? '',
      paymentMethodName: data['paymentMethodName'] as String? ?? '',
      status: data['status'] as String? ?? '',
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] is String
          ? DateTime.parse(data['timestamp'] as String)
          : (data['timestamp'] as Timestamp).toDate())
          : DateTime.now(),
      deliveryDate: data['deliveryDate'] != null
          ? DateTime.parse(data['deliveryDate'] as String)
          : null,
      shippingAddress: data['shippingAddress'] as String? ?? '',
      shippingPhoneNumber: data['shippingPhoneNumber'] as String? ?? '',
      userId: data['userId'] as String?,
      userName: data['userName'] as String?,
      items: data['items'] != null
          ? List<Map<String, dynamic>>.from(data['items'] as List<dynamic>)
          : [],
    );
  }
}