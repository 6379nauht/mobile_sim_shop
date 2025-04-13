import 'package:flutter/material.dart';

class AppHelperFunctions {
  static Color? getColor(String value) {
    switch (value.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
        return Colors.grey;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'cyan':
        return Colors.cyan;
      case 'teal':
        return Colors.teal;
      default:
        return null;
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static String capitalizeEachWord(String text) {
    return text
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  // Hàm hiển thị dialog xác nhận dùng chung
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true, // Cho phép đóng dialog khi nhấn ngoài
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false), // Trả về false khi hủy
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true), // Trả về true khi xác nhận
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
    return result ?? false; // Mặc định trả về false nếu dialog bị đóng mà không chọn
  }
}