import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constants/sizes.dart';

class BillingAmountSection extends StatelessWidget {
  const BillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium,),
            Text('18.000VND', style: Theme.of(context).textTheme.labelLarge,)
          ],
        ),
        SizedBox(
          height: AppSizes.spaceBtwSections.h / 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shipping fee', style: Theme.of(context).textTheme.bodyMedium,),
            Text('18.000VND', style: Theme.of(context).textTheme.labelLarge,)
          ],
        ),
        SizedBox(
          height: AppSizes.spaceBtwSections.h / 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium,),
            Text('18.000VND', style: Theme.of(context).textTheme.labelLarge,)
          ],
        ),
        SizedBox(
          height: AppSizes.spaceBtwSections.h / 2,
        ),

        ///Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order total', style: Theme.of(context).textTheme.bodyMedium,),
            Text('18.000VND', style: Theme.of(context).textTheme.labelLarge,)
          ],
        )
      ],
    );
  }
}
