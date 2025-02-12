import 'package:intl/intl.dart';

class AppFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Xóa khoảng trắng và dấu không cần thiết
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Kiểm tra nếu số bắt đầu bằng "0", đổi thành +84
    if (cleanNumber.startsWith('0')) {
      cleanNumber = '+84${cleanNumber.substring(1)}';
    }

    // Định dạng số theo chuẩn (ví dụ: +84 912 345 678)
    final formatter = NumberFormat('+# ## ### ####');
    return formatter.format(int.tryParse(cleanNumber) ?? 0);
  }
}