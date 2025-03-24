import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/popups/loaders.dart';
import 'package:mobile_sim_shop/core/utils/constants/text_strings.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_state.dart';
import 'package:mobile_sim_shop/features/auth/presentation/pages/signin/widgets/signin_header.dart';

import '../../../../../core/network/network_bloc.dart';
import '../../../../../core/network/network_state.dart';
import '../../../../../core/popups/full_page_loader.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/styles/spacing_styles.dart';
import '../../../../../core/utils/constants/image_strings.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/login_signup/form_divider.dart';
import '../../../../../core/widgets/login_signup/social_buttons.dart';
import '../../blocs/signin/signin_event.dart';
import 'widgets/signin_form.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [

        ///Check internet
        BlocListener<NetworkBloc, NetworkState>(
          listener: (context, state) {
            if (state is NetworkDisconnected) {
              AppLoaders.customSnackbar(
                context: context,
                title: AppTexts.disConnectedTitle,
                msg: AppTexts.disConnectedSubTitle,
                contentType: ContentType.failure,
              );
              AppFullPageLoader.stopLoading(context);
            }
          },
        ),

        ///Signin
        BlocListener<SigninBloc, SigninState>(
          listenWhen: (previous, current) {
            return previous.status != current.status ||
                (current.status == SigninStatus.failure && current.errorMessage != null) ||
                (current.status == SigninStatus.authenticated);
          },
          listener: (context, state) {
            if (state.status == SigninStatus.loading) {
              /// Chỉ mở loading dialog nếu chưa hiển thị
              if (!AppFullPageLoader.isLoading()) {
                AppFullPageLoader.openLoadingDialog(context, '', AppImages.load);
              }
            }

            /// Khi trạng thái không còn là loading
            if (state.status != SigninStatus.loading &&
                AppFullPageLoader.isLoading()) {
              AppFullPageLoader.stopLoading(context);
            }
            if (state.status == SigninStatus.authenticated) {
              context.goNamed(Routes.homeName);
            }
            if (state.status == SigninStatus.failure && state.errorMessage != null && !state.errorShow) {
              AppLoaders.customSnackbar(
                context: context,
                title: "Lỗi",
                msg: state.errorMessage!,
                contentType: ContentType.failure,
              );
              context.read<SigninBloc>().add(MarkErrorAsShown());
            }
          },
        ),
      ],
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
