// lib/features/store/domain/entities/invoice.dart
class Invoice {
  final String id;
  final String orderNumber;
  final double totalAmount;
  final String paymentMethodId;
  final String paymentMethodName;
  final String status;
  final DateTime timestamp;
  final DateTime? deliveryDate;
  final String shippingAddress;
  final String shippingPhoneNumber;
  final String? userId;
  final String? userName;
  final List<Map<String, dynamic>> items;

  Invoice({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.paymentMethodId,
    required this.paymentMethodName,
    required this.status,
    required this.timestamp,
    this.deliveryDate,
    required this.shippingAddress,
    this.userId,
    this.userName,
    required this.items,
    required this.shippingPhoneNumber
  });
}