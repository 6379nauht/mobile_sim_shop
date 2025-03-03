import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/colors.dart';

class PriceButton extends StatelessWidget {
  final String label;

  const PriceButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 100.w, // 👈 Đặt kích thước tối thiểu
        minHeight: 50.h,
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.accent,
          backgroundColor: AppColors.white,
          side: const BorderSide(color: Colors.orange),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}
