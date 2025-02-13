import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/%20common/widgets/login_signup/form_divider.dart';
import 'package:mobile_sim_shop/%20common/widgets/login_signup/social_buttons.dart';
import 'package:mobile_sim_shop/presentation/auth/pages/signup/widgets/signup_form.dart';

import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_strings.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Text(
                AppTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSizes.spaceBtwSections,),

              //Form
              const SignupForm(),
              SizedBox(height: AppSizes.spaceBtwSections.h,),

              //Divider
              const FormDivider(text: AppTexts.orSignUpWith,),
              SizedBox(height: AppSizes.spaceBtwSections.h,),

              //Social buttons
              const SocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}


