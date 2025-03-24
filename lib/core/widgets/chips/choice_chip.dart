import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';

import '../../utils/constants/colors.dart';

class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });
  final String text;
  final bool selected;
  final void Function(bool)? onSelected;
  @override
  Widget build(BuildContext context) {
    final isColor = AppHelperFunctions.getColor(text) != null;

    if (isColor) {
      // Nếu là chip màu, sử dụng Container tùy chỉnh thay vì ChoiceChip
      return InkWell(
        onTap: () => onSelected?.call(!selected),
        borderRadius: BorderRadius.circular(25.r),
        child: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppHelperFunctions.getColor(text),
          ),
          child: selected
              ? Center(
            child: Icon(
              Icons.check,
              color: AppColors.white,
              size: 24.sp,
            ),
          )
              : null,
        ),
      );
    } else {
      // Sử dụng ChoiceChip thông thường cho trường hợp không phải là màu
      return ChoiceChip(
        label: Text(text),
        selected: selected,
        onSelected: onSelected,
        labelStyle: TextStyle(color: selected ? AppColors.white : null),
        showCheckmark: false,
      );
    }
  }
}