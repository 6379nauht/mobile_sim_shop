import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/password_configuration/password_configuration_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/password_configuration/password_configuration_state.dart';
import '../../../../../core/popups/loaders.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/utils/constants/image_strings.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/utils/constants/text_strings.dart';
import '../../blocs/password_configuration/password_configuration_event.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  context
                      .read<PasswordConfigurationBloc>()
                      .add(const ResetStateEvent());
                  context.goNamed(Routes.signinName);
                },
                icon: const Icon(CupertinoIcons.clear))
          ],
        ),
        body:
            BlocConsumer<PasswordConfigurationBloc, PasswordConfigurationState>(
                listener: (_, state) {
                  if (state.status == PasswordStatus.success) {
                    // Hiển thị thông báo khi resend email thành công
                    AppLoaders.customSnackbar(
                      context: context,
                      title: 'Thành công',
                      msg: 'Email reset đã được gửi lại!',
                      contentType: ContentType.success,
                    );
                  } else if (state.status == PasswordStatus.failure && !state.errorShow) {
                    // Hiển thị lỗi nếu resend thất bại
                    AppLoaders.customSnackbar(
                      context: context,
                      title: 'Lỗi',
                      msg: state.errorMessage,
                      contentType: ContentType.failure,
                    );
                    context.read<PasswordConfigurationBloc>().add(MarkErrorAsShown());
                  }

                },
                builder: (_, state) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.defaultSpace.w),
                      child: Column(
                        children: [
                          //Image
                          Image(
                            image: const AssetImage(AppImages.emailVerify),
                            width: AppSizes.imageWidth.sw,
                          ),
                          SizedBox(
                            height: AppSizes.spaceBtwSections.h,
                          ),

                          //Title & SubTitle
                          Text(
                            AppTexts.changeYourPasswordTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: AppSizes.spaceBtwItems.h,
                          ),
                          Text(
                            AppTexts.changeYourPasswordSubTitle,
                            style: Theme.of(context).textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: AppSizes.spaceBtwSections.h,
                          ),

                          // Buttons
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => context.goNamed(Routes.signinName),
                              child: const Text(AppTexts.done),
                            ),
                          ),
                          SizedBox(
                            height: AppSizes.spaceBtwItems.h,
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: state.status == PasswordStatus.loading
                                  ? null
                                  : () => context
                                  .read<PasswordConfigurationBloc>()
                                  .add(ResetPasswordEvent()),
                              child: state.status == PasswordStatus.loading
                                  ? const CircularProgressIndicator()
                                  : const Text(AppTexts.resendEmail),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }));
  }
}
