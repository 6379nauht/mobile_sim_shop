
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/widgets/loaders/animation_loader.dart';

class AppFullPageLoader {
  static bool _isLoaderShowing = false;
  static void openLoadingDialog(
      BuildContext context, String text, String animation) {
    _isLoaderShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Container(
          color: AppHelperFunctions.isDarkMode(context)
              ? AppColors.dark
              : AppColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 250.h,
              ),
              AppAnimationLoaderWidget(
                text: text,
                animation: animation,
              )
            ],
          ),
        ),
      ),
    );
  }

  static stopLoading(BuildContext context) {
    // Chỉ pop nếu loading dialog đang hiển thị
    if (_isLoaderShowing) {
      Navigator.pop(context);
      _isLoaderShowing = false;
    }
  }
  // Chỉ pop nếu loading dialog đang hiển thị
  static bool isLoading() {
    return _isLoaderShowing;
  }
}
