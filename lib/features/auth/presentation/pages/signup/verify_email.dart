
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signup/signup_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signup/signup_event.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signup/signup_state.dart';
import '../../../../../core/popups/full_page_loader.dart';
import '../../../../../core/utils/constants/image_strings.dart';
import '../../../../../core/utils/constants/text_strings.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          context.goNamed(Routes.verifySuccessName);
        }

        ///Chuyển về trang loginPage
        if (state.status == SignupStatus.initial) {
          context.goNamed(Routes.signupName);
        }

        ///Dừng loading
        if (state.status != SignupStatus.loading &&
            AppFullPageLoader.isLoading()) {
          AppFullPageLoader.stopLoading(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                // Gọi event hủy xác minh trước khi quay về trang đăng nhập
                context.read<SignupBloc>().add(const CancelVerification());
              },
              icon: const Icon(CupertinoIcons.clear),
            )
          ],
        ),
        body: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            if (state.status == SignupStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.defaultSpace.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage(AppImages.emailVerify),
                        width: AppSizes.imageWidth.sw,
                      ),
                      SizedBox(height: AppSizes.spaceBtwSections.h),
                      Text(
                        AppTexts.verifyEmailTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSizes.spaceBtwItems.h),
                      Text(
                        AppTexts.verifyEmailSubTitle,
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
