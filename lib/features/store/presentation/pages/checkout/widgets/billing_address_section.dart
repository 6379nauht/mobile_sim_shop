import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';

class BillingAddressSection extends StatelessWidget {
  const BillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(
          title: 'Shipping Address',
          buttonTitle: 'Change',
          onPressed: () {},
        ),
        SizedBox(
          height: AppSizes.spaceBtwItems.h / 2,
        ),
        Row(
          children: [
            Icon(
              Icons.phone,
              color: Colors.grey,
              size: 16.sp,
            ),
            SizedBox(
              width: AppSizes.spaceBtwItems.w,
            ),
            Text(
              '+84 345417969',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        SizedBox(
          height: AppSizes.spaceBtwItems.h / 2,
        ),
        Row(
          children: [
            Icon(
              Icons.location_history,
              color: Colors.grey,
              size: 16.sp,
            ),
            SizedBox(
              width: AppSizes.spaceBtwItems.w,
            ),
            Expanded(
                child:
                    Text('Ấp Hòa Thịnh, Hòa Bình Thanh, Châu Thành, An Gang',
                    style: Theme.of(context).textTheme.bodyMedium, softWrap: true,
                    ))
          ],
        )
      ],
    );
  }
}
