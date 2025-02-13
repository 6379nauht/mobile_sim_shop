import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/%20common/navigators/navigator.dart';
import 'package:mobile_sim_shop/presentation/auth/pages/signup/verify_email.dart';
import 'package:mobile_sim_shop/presentation/auth/pages/signup/widgets/terms_conditions_checkbox.dart';

import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/utils/constants/text_strings.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              //firstname
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: AppTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              SizedBox(
                width: AppSizes.spaceBtwInputFields.w,
              ),

              //lastname
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: AppTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: AppSizes.spaceBtwInputFields.h,
          ),

          //UserName
          TextFormField(
            decoration: const InputDecoration(
                labelText: AppTexts.userName,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),
          SizedBox(
            height: AppSizes.spaceBtwInputFields.h,
          ),

          //Email
          TextFormField(
            decoration: const InputDecoration(
                labelText: AppTexts.email,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),
          SizedBox(
            height: AppSizes.spaceBtwInputFields.h,
          ),

          //Phone number
          TextFormField(
            decoration: const InputDecoration(
                labelText: AppTexts.phoneNumber,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),
          SizedBox(
            height: AppSizes.spaceBtwInputFields.h,
          ),

          //Password
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: AppTexts.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),
          SizedBox(
            height: AppSizes.spaceBtwSections.h,
          ),

          //Terms&Conditions checkbox
          const TermsAndConditionCheckbox(),
          SizedBox(
            height: AppSizes.spaceBtwSections.h,
          ),

          //Button create account
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => AppNavigator.push(context, const VerifyEmailPage()),
                child: const Text(AppTexts.createAccount)),
          ),
        ],
      ),);
  }
}
