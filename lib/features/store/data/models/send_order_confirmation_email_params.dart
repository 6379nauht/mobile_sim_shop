import 'package:mobile_sim_shop/features/store/domain/entities/invoice.dart';

class SendOrderConfirmationEmailParams{
  final String recipientEmail;
  final Invoice invoice;
  SendOrderConfirmationEmailParams({required this.recipientEmail, required this.invoice});
}