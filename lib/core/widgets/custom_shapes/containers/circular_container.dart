import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';


class AppCircularContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final double radius;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Widget? child;

  const AppCircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,

    this.radius = 400,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = AppColors.white,
    this.child,
    this.margin ,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}