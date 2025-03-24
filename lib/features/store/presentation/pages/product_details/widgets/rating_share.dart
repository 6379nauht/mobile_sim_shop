
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../core/utils/constants/sizes.dart';

class RatingAndShare extends StatelessWidget {
  const RatingAndShare({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(color: Colors.amber, Iconsax.star5, size: 24.sp),
              SizedBox(width: AppSizes.spaceBtwItems.w / 2,),
              Text.rich(
                  TextSpan(
                      children: [
                        TextSpan(text: '5.0', style: Theme.of(context).textTheme.bodyLarge),
                        const TextSpan(text: '(199)'),
                      ]
                  )
              )
            ],
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.share, size: AppSizes.iconMd.sp,)),
        ]
    );
  }
}