
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class AppPrimaryHeaderContainer extends StatelessWidget {
  const AppPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCurvedEdgeWidget(
      child: Container(
        color: AppColors.primary,
        child: Stack(
          children: [
            Positioned(
              top: -150.h,
              right: -250.w,
              child: AppCircularContainer(
                width: 400.w,
                height: 400.h,
                radius: 400.r,
                backgroundColor: AppColors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100.h,
              right: -300.w,
              child: AppCircularContainer(
                width: 350.w,
                height: 350.h,
                radius: 350.r,
                backgroundColor: AppColors.textWhite.withOpacity(0.1),
              ),
            ),
            child
          ],
        ),
      ),
    );
  }
}

