import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';

class AppOutlinedButtonTheme {
  AppOutlinedButtonTheme._();

  //light
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.black,
      side: const BorderSide(color: AppColors.primary),
      textStyle: TextStyle(fontSize: 16.sp, color: AppColors.black, fontWeight: FontWeight.w600),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
    )
  );


  //dark
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.primary),
        textStyle: TextStyle(fontSize: 16.sp, color: AppColors.white, fontWeight: FontWeight.w600),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      )
  );
}