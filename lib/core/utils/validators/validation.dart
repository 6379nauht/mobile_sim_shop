

import 'package:intl/intl.dart';

class AppValidator {
  static String? validateEmail(String? value) {
    if(value == null || value.isEmpty) {
      return 'Email is required.';
    }
    final emailRegExp = RegExp(r"^[^@]+@[^@]+\.[^@]+$");

    if(!emailRegExp.hasMatch(value.trim())) {
      return 'Invalid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if(value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if(value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    if(!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    if(!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    if(!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if(value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    final phoneRegExp = RegExp(r'^\d{10}$');

    if(!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }

  static String formatPrice(double price) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
    return format.format(price);
  }

}