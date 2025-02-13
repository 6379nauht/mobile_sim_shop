import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/%20common/navigators/navigator.dart';
import 'package:mobile_sim_shop/presentation/auth/pages/password_configuration/reset_password.dart';

import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_strings.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.defaultSpace.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Headings
            Text(
              AppTexts.forgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: AppSizes.spaceBtwItems.h,
            ),

            Text(
              AppTexts.forgetPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(
              height: AppSizes.spaceBtwSections.h * 2,
            ),

            //TextField
            TextFormField(
              decoration: const InputDecoration(
                  labelText: AppTexts.email,
                  prefixIcon: Icon(Iconsax.direct_right)),
            ),
            SizedBox(
              height: AppSizes.spaceBtwSections.h,
            ),

            //Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () =>
                      AppNavigator.pushReplacement(context, const ResetPassword()),
                  child: const Text(AppTexts.submit)),
            )
          ],
        ),
      ),
    );
  }
}
