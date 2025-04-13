import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mobile_sim_shop/core/utils/validators/validation.dart';
import 'package:mobile_sim_shop/features/store/data/models/send_order_confirmation_email_params.dart';

import '../../../../core/dependency_injection/locator.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/invoice.dart';
import '../models/invoice_model.dart';

abstract class CartFirebaseService {
  Future<Either<Failure, void>> createInvoice(Invoice invoice);
  Future<Either<Failure, void>> sendOrderConfirmationEmail(SendOrderConfirmationEmailParams params);
}

class CartFirebaseServiceImpl implements CartFirebaseService {
  @override
  Future<Either<Failure, void>> createInvoice(Invoice invoice) async {
    try {
      // Chuyển Invoice thành InvoiceModel để lưu
      final invoiceModel = InvoiceModel(
        id: invoice.id,
        orderNumber: invoice.orderNumber,
        totalAmount: invoice.totalAmount,
        paymentMethodId: invoice.paymentMethodId,
        paymentMethodName: invoice.paymentMethodName,
        status: invoice.status,
        timestamp: invoice.timestamp,
        deliveryDate: invoice.deliveryDate,
        shippingAddress: invoice.shippingAddress,
        shippingPhoneNumber: invoice.shippingPhoneNumber,
        userId: invoice.userId,
        userName: invoice.userName,
        items: invoice.items,
      );

      await getIt<FirebaseFirestore>()
          .collection('invoices')
          .doc(invoiceModel.id)
          .set(invoiceModel.toJson());
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Failed to create invoice in Firestore'));
    } catch (e) {
      // Xử lý lỗi chung
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendOrderConfirmationEmail(SendOrderConfirmationEmailParams params) async {
    try {
      final smtpServer = gmail(dotenv.env['SmtpServer_Email'] ?? '', dotenv.env['SmtpServer_Password'] ?? '');

      // Tạo nội dung email
      final message = Message()
        ..from = const Address('6379nauht@gmail.com', 'CUA HANG AFE')
        ..recipients.add(params.recipientEmail)
        ..subject = 'Xác nhận đơn hàng #${params.invoice.orderNumber}'
        ..html = _buildEmailContent(params.invoice);

      // Gửi email
      final sendReport = await send(message, smtpServer);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Không thể gửi email xác nhận: $e'));
    }
  }


  String _buildEmailContent(Invoice invoice) {
    final itemsHtml = invoice.items.map((item) {
      // Xử lý price và quantity an toàn, hỗ trợ số thập phân
      final price = double.tryParse(item['price'].toString()) ?? 0.0;
      final quantity = int.tryParse(item['quantity'].toString()) ?? 0;
      final total = price * quantity;

      return '''
      <tr>
        <td class="py-3 px-4">${item['title'] ?? 'Không xác định'}</td>
        <td class="py-3 px-4 text-center">$quantity</td>
        <td class="py-3 px-4 text-end">${price.toStringAsFixed(0)}</td>
        <td class="py-3 px-4 text-end">${total.toStringAsFixed(0)}</td>
      </tr>
    ''';
    }).join();

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
      <style>
        body { background-color: #f0f4f3; }
        .email-container { max-width: 750px; margin: 30px auto; }
        .header { background: linear-gradient(135deg, #28a745, #34c759); color: white; padding: 25px; border-radius: 10px 10px 0 0; }
        .content { background-color: white; padding: 30px; border-radius: 0 0 10px 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); text-align: center; }
        .table th, .table td { border: 1px solid #e0e0e0; vertical-align: middle; }
        .table th { background-color: #f7f9f8; color: #34495e; font-weight: 600; }
        .table { border-collapse: collapse; width: 100%; margin-left: auto; margin-right: auto; }
        .table th:nth-child(1), .table td:nth-child(1) { width: 50%; }
        .table th:nth-child(2), .table td:nth-child(2) { width: 15%; }
        .table th:nth-child(3), .table td:nth-child(3) { width: 20%; }
        .table th:nth-child(4), .table td:nth-child(4) { width: 15%; }
        .footer { margin-top: 25px; text-align: center; color: #7f8c8d; font-size: 0.9rem; }
        .lead { color: #2c3e50; }
        .total { background-color: #f7f9f8; padding: 10px 20px; border-radius: 8px; }
        .order-info { text-align: left; display: inline-block; width: 100%; max-width: 500px; }
      </style>
    </head>
    <body>
      <div class="email-container">
        <div class="header text-center">
          <h2 class="mb-0">Xác nhận đơn hàng</h2>
        </div>
        <div class="content">
          <p class="lead mb-4">Cảm ơn bạn đã đặt hàng tại <strong>CỬA HÀNG AFE</strong>!</p>
          <div class="mb-5 order-info">
            <p><strong>Số đơn hàng:</strong> ${invoice.orderNumber}</p>
            <p><strong>Ngày đặt hàng:</strong> ${invoice.timestamp.toString()}</p>
            <p><strong>Tên người nhận:</strong> ${invoice.userName} ?? 'Không có'}</p>
            <p><strong>Địa chỉ giao hàng:</strong> ${invoice.shippingAddress ?? 'Không có'}</p>
            <p><strong>Số điện thoại:</strong> ${invoice.shippingPhoneNumber ?? 'Không có'}</p>
            <p><strong>Phương thức thanh toán:</strong> ${invoice.paymentMethodName ?? 'Không xác định'}</p>
          </div>
          <h3 class="mb-4">Chi tiết đơn hàng</h3>
          <div class="table-responsive">
            <table class="table table-bordered table-hover">
              <thead>
                <tr>
                  <th class="py-3 px-4">Sản phẩm</th>
                  <th class="py-3 px-4 text-center">Số lượng</th>
                  <th class="py-3 px-4 text-end">Giá</th>
                  <th class="py-3 px-4 text-end">Tổng</th>
                </tr>
              </thead>
              <tbody>
                $itemsHtml
              </tbody>
            </table>
          </div>
          <div class="total mt-4">
            <p class="fs-5 mb-0"><strong>Tổng cộng:</strong> ${AppValidator.formatPrice(double.parse(invoice.totalAmount.toStringAsFixed(0)))}</p>
          </div>
          <p class="text-muted mt-3">Chúng tôi sẽ thông báo khi đơn hàng được vận chuyển.</p>
        </div>
        <div class="footer">
          <p>© 2025 CỬA HÀNG AFE. Mọi quyền được bảo lưu.</p>
        </div>
      </div>
    </body>
    </html>
  ''';
  }
}
