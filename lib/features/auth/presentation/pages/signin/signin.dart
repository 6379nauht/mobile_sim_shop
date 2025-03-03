import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/popups/loaders.dart';
import 'package:mobile_sim_shop/core/utils/constants/text_strings.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:mobile_sim_shop/features/auth/presentation/pages/signin/widgets/signin_header.dart';

import '../../../../../core/network/network_bloc.dart';
import '../../../../../core/network/network_state.dart';
import '../../../../../core/styles/spacing_styles.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/login_signup/form_divider.dart';
import '../../../../../core/widgets/login_signup/social_buttons.dart';
import 'widgets/signin_form.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if (state is NetworkDisconnected) {
          AppLoaders.customSnackbar(
              context: context,
              title: AppTexts.disConnectedTitle,
              msg: AppTexts.disConnectedSubTitle,
              contentType: ContentType.failure);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: AppSpacingStyles.paddingWithAppBarHeight,
            child: Column(
              children: [
                // Logo, title & sub-title
                const SigninHeader(),
                // Form
                const SigninForm(),
                // Divider
                const FormDivider(text: AppTexts.orSignInWith),
                SizedBox(height: AppSizes.spaceBtwSections.h),
                // Footer
                const SocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
