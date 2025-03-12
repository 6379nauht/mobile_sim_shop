import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/sizes.dart';

class ProductTitleText extends StatelessWidget {
  const ProductTitleText(
      {super.key, required this.title,
      this.smallSizes = false,
      this.maxLines = 2,
      this.textAlign = TextAlign.left});
  final String title;
  final bool smallSizes;
  final int maxLines;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: smallSizes
          ? Theme.of(context).textTheme.labelLarge
          : Theme.of(context).textTheme.titleSmall,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
