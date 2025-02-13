
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/%20common/navigators/navigator.dart';
import 'package:mobile_sim_shop/presentation/auth/pages/signup/signup.dart';

import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/utils/constants/text_strings.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceBtwSections),
          child: Column(
            children: [
              //Email
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: AppTexts.email,
                ),
              ),
              SizedBox(
                height: AppSizes.spaceBtwInputFields.h,
              ),

              //Password
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: AppTexts.password,
                  suffixIcon: Icon(Iconsax.eye_slash),
                ),
              ),
              SizedBox(
                height: AppSizes.spaceBtwInputFields.h / 2,
              ),

              //Remember Me & Forget Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Remember Me
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      const Text(AppTexts.rememberMe),
                    ],
                  ),

                  //forget password
                  TextButton(
                      onPressed: () {}, child: const Text(AppTexts.forgetPassword)),
                ],
              ),
              SizedBox(
                height: AppSizes.spaceBtwSections.h,
              ),

              //Sign in button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text(AppTexts.signIn))),
              SizedBox(
                height: AppSizes.spaceBtwItems.h,
              ),

              //create account button
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () => AppNavigator.push(context, const SignupPage()), child: const Text(AppTexts.createAccount)))
            ],
          ),
        ));
  }
}