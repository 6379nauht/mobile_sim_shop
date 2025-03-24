import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';

class BillingPaymentsSection extends StatelessWidget {
  const BillingPaymentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeading(
          title: 'Payment Method',
          buttonTitle: 'Change',
          onPressed: (){},
        ),
        Row(
          children: [
            RoundedContainer(
              width: 60.w,
              height: 60.h,
              backgroundColor: AppHelperFunctions.isDarkMode(context) ? AppColors.light : AppColors.white,
              padding: EdgeInsets.all(AppSizes.sm.r),
              child: const Image(image: AssetImage(AppImages.iconPhone), fit: BoxFit.contain,),
            ),

            SizedBox(width: AppSizes.spaceBtwItems.w /2 ,),
            Text('Paypal', style: Theme.of(context).textTheme.bodyLarge,)
          ],
        )
      ],
    );
  }
}
