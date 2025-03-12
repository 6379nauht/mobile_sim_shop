import 'package:flutter/material.dart';

import '../../helpers/helper_functions.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class CircularIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final double iconSize;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onPressed;

  const CircularIcon({
    super.key,
    required this.icon,
    this.iconSize = AppSizes.lg,
    this.backgroundColor,
    this.iconColor,
    this.onPressed, this.width, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ??
            (AppHelperFunctions.isDarkMode(context)
                ? AppColors.black.withOpacity(0.9)
                : AppColors.white.withOpacity(0.9)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}
