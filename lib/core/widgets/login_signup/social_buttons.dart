
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_state.dart';

import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/constants/image_strings.dart';
import '../../../core/utils/constants/sizes.dart';
import '../../../features/auth/presentation/blocs/signin/signin_event.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninBloc, SigninState>
      (builder: (_, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey),
                  borderRadius: BorderRadius.circular(100.r)),
              child: IconButton(
                onPressed: state.status == SigninStatus.loading
                    ? null
                    : () => context.read<SigninBloc>().add(SignInWithGoogle()),
                icon: Image(
                  image: const AssetImage(AppImages.google),
                  width: AppSizes.iconMd.w,
                  height: AppSizes.iconMd.h,
                ),
              ),
            ),
          ],
        );
    });
  }
}
