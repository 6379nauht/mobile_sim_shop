import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/popups/loaders.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/password_configuration/password_configuration_bloc.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/utils/constants/text_strings.dart';
import '../../blocs/password_configuration/password_configuration_event.dart';
import '../../blocs/password_configuration/password_configuration_state.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<PasswordConfigurationBloc, PasswordConfigurationState>(
        listener: (_, state) {
          if (state.status == PasswordStatus.success) {
            // Điều hướng đến trang reset password khi thành công
            context.goNamed(Routes.resetPasswordName);
          } else if (state.status == PasswordStatus.failure &&
              !state.errorShow) {
            // Hiển thị lỗi nếu có
            AppLoaders.customSnackbar(
                context: context,
                title: 'Lỗi',
                msg: state.errorMessage,
                contentType: ContentType.failure);
            // Đánh dấu lỗi đã hiển thị
            context.read<PasswordConfigurationBloc>().add(MarkErrorAsShown());
          }
        },
        builder: (_, state) {
          return Padding(
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

                // TextField
                TextFormField(
                  onChanged: (value) => context
                      .read<PasswordConfigurationBloc>()
                      .add(EmailChanged(value)),
                  decoration: InputDecoration(
                    labelText: AppTexts.email,
                    prefixIcon: const Icon(Iconsax.direct_right),
                    errorText: state.status == PasswordStatus.failure &&
                        !state.errorShow
                        ? state.errorMessage
                        : null,
                  ),
                ),
                SizedBox(
                  height: AppSizes.spaceBtwSections.h,
                ),

                //Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.status == PasswordStatus.loading
                        ? null // Vô hiệu hóa nút khi đang loading
                        : () => context
                        .read<PasswordConfigurationBloc>()
                        .add(ResetPasswordEvent()),
                    child: state.status == PasswordStatus.loading
                        ? const CircularProgressIndicator()
                        : const Text(AppTexts.submit),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
