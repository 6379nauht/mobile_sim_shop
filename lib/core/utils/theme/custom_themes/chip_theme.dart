 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';

class AppChipTheme {
  AppChipTheme._();

  //light
  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: AppColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: AppColors.black),
    selectedColor: AppColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    checkmarkColor: AppColors.white,
  );

  //dark
  static ChipThemeData darkChipTheme = ChipThemeData(
    disabledColor: AppColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: AppColors.white),
    selectedColor: AppColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    checkmarkColor: AppColors.white,
  );
}