import 'package:flutter/material.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  // --Light
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primary,
      disabledBackgroundColor: AppColors.grey,
      disabledForegroundColor: AppColors.grey,
      side: const BorderSide(color: AppColors.primary),
      padding: EdgeInsets.symmetric(vertical: 18.sp),
      textStyle: TextStyle(fontSize: 16.sp, color: AppColors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))
    ),
  );

  //Dark

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.grey,
        disabledForegroundColor: AppColors.grey,
        side: const BorderSide(color: AppColors.primary),
        padding: EdgeInsets.symmetric(vertical: 18.sp),
        textStyle: TextStyle(fontSize: 16.sp, color: AppColors.white, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))
    ),
  );
}