import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/helper_functions.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class CircularImage extends StatelessWidget {
  const CircularImage(
      {super.key,
      this.fit = BoxFit.contain,
      required this.image,
      this.isNetworkImage = false,
      this.overlayColor,
      this.backgroundColor,
      this.width = 56,
      this.height = 56,
      this.padding = 3});
  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      padding: EdgeInsets.all(padding.r),
      decoration: BoxDecoration(
          color: backgroundColor ?? (AppHelperFunctions.isDarkMode(context)
              ? AppColors.black
              : AppColors.white),
    shape: BoxShape.circle),
      child: Image(
        fit: fit,
        image: isNetworkImage ?NetworkImage(image) : AssetImage(image) as ImageProvider,
        color: overlayColor,
      ),
    );
  }
}
