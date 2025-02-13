import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';

class AppTextFieldTheme {
  AppTextFieldTheme._();

  //light
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: AppColors.grey,
    suffixIconColor: AppColors.grey,
    labelStyle: const TextStyle().copyWith(fontSize: 14.sp, color: AppColors.black),
    hintStyle: const TextStyle().copyWith(fontSize: 14.sp, color: AppColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: AppColors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: const BorderSide(width: 1, color: AppColors.grey)
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: const BorderSide(width: 1, color: AppColors.grey)
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(width: 1, color: AppColors.darkerGrey)
    ),
    errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(width: 1, color: AppColors.error)
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(width: 2, color: AppColors.warning)
    ),
  );

  //dark
  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: AppColors.grey,
    suffixIconColor: AppColors.grey,
    labelStyle: const TextStyle().copyWith(fontSize: 14.sp, color: AppColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: 14.sp, color: AppColors.white),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: AppColors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(width: 1, color: AppColors.grey)
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(width: 1, color: AppColors.grey)
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(width: 1, color: AppColors.darkerGrey)
    ),
    errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(width: 1, color: AppColors.error)
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(width: 2, color: AppColors.warning)
    ),
  );
}