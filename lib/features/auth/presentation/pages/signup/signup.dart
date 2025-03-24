import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/popups/loaders.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signup/signup_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/pages/signup/widgets/signup_form.dart';

import '../../../../../core/popups/full_page_loader.dart';
import '../../../../../core/utils/constants/image_strings.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/utils/constants/text_strings.dart';
import '../../blocs/signup/signup_event.dart';
import '../../blocs/signup/signup_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<SignupBloc, SignupState>(
          listenWhen: (previous, current) {
            // Lắng nghe mọi thay đổi trạng thái
            return previous.status != current.status ||
                (current.status == SignupStatus.failure &&
                    current.errorMessage != null &&
                    !current.errorShown) ||
                (current.status == SignupStatus.success && !current.successShown);
          },

          listener: (context, state) {
            if (state.status == SignupStatus.loading) {
              /// Chỉ mở loading dialog nếu chưa hiển thị
              if (!AppFullPageLoader.isLoading()) {
                AppFullPageLoader.openLoadingDialog(context, '', AppImages.load);
              }
            }

            /// Khi trạng thái không còn là loading
            if (state.status != SignupStatus.loading &&
                AppFullPageLoader.isLoading()) {
              AppFullPageLoader.stopLoading(context);
            }

            /// Khi đăng ký thành công
            if (state.status == SignupStatus.success && !state.successShown) {
              AppLoaders.customSnackbar(
                context: context,
                title: "Chúc mừng!",
                msg: "Tài khoản của bạn đã được tạo! Vui lòng xác nhận email để tiếp tục.",
                contentType: ContentType.success,
              );

              /// Chuyển trang sang VerifyEmailPage
              context.goNamed(Routes.verifyEmailName);

              /// Đánh dấu đã hiển thị thành công để tránh hiển thị lại
              context.read<SignupBloc>().add(MarkSuccessShown());
            }

            /// Khi có lỗi xảy ra
            if (state.status == SignupStatus.failure &&
                state.errorMessage != null &&
                !state.errorShown) {
              AppLoaders.customSnackbar(
                context: context,
                title: "Error",
                msg: state.errorMessage!,
                contentType: ContentType.failure,
              );

              /// Đánh dấu lỗi đã được hiển thị (bạn cần thêm một phương thức cho việc này)
              context.read<SignupBloc>().add(MarkErrorAsShown());
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.defaultSpace.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Text(
                    AppTexts.signupTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(
                    height: AppSizes.spaceBtwSections.h,
                  ),

                  //Form
                  const SignupForm(),
                  SizedBox(
                    height: AppSizes.spaceBtwSections.h,
                  ),

                ],
              ),
            ),
          )),
    );
  }
}
