import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppAppBarTheme {
  AppAppBarTheme._();

  //light
  static final lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.transparent,
    surfaceTintColor: AppColors.transparent,
    iconTheme: IconThemeData(color: AppColors.black, size: 24.sp),
    actionsIconTheme: IconThemeData(color: AppColors.black, size: 24.sp),
    titleTextStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.black),
  );

  //dark
  static final darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.transparent,
    surfaceTintColor: AppColors.transparent,
    iconTheme: IconThemeData(color: AppColors.black, size: 24.sp),
    actionsIconTheme: IconThemeData(color: AppColors.white, size: 24.sp),
    titleTextStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.white),
  );
}