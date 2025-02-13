import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/text_strings.dart';
import 'package:mobile_sim_shop/presentation/auth/pages/login/widgets/login_header.dart';

import '../../../../ common/styles/spacing_styles.dart';
import '../../../../ common/widgets/login_signup/form_divider.dart';
import '../../../../ common/widgets/login_signup/social_buttons.dart';
import '../../../../core/utils/constants/sizes.dart';
import 'widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacingStyles.paddingWithAppBarHeight,
          child: Column(
            children: [
              //logo, title & sub-title
              const LoginHeader(),
              //Form
              const LoginForm(),
              //Divider
              const FormDivider( text: AppTexts.orSignInWith,),
              SizedBox(height: AppSizes.spaceBtwSections.h,),
              //Footer
              const SocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}


