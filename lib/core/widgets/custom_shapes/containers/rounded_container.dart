import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class RoundedContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final double radius;
  final bool showBorder;
  final Color borderColor;
  final Widget? child;
  const RoundedContainer({
    super.key,
    this.width ,
    this.height ,
    this.padding,
    this.margin,
    this.backgroundColor = AppColors.white,
    this.radius = AppSizes.cardRadiusLg,
    this.showBorder = false,
    this.borderColor = AppColors.borderPrimary, this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
