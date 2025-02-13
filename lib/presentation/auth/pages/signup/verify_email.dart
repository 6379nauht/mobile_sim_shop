import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/%20common/navigators/navigator.dart';
import 'package:mobile_sim_shop/%20common/widgets/success_page/success_page.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/presentation/auth/pages/login/login.dart';

import '../../../../core/utils/constants/image_strings.dart';
import '../../../../core/utils/constants/text_strings.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => AppNavigator.pushAndRemove(context, const LoginPage()),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(AppSizes.defaultSpace.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Image 60% màn hình
                Image(
                  image: const AssetImage(AppImages.emailVerify),
                  width: AppSizes.imageWidth.sw,
                ),
                SizedBox(
                  height: AppSizes.spaceBtwSections.h,
                ),

                //Title & SubTitle
                Text(
                  AppTexts.accountSuccessTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: AppSizes.spaceBtwItems.h,
                ),

                Text(
                  AppTexts.accountSuccessSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: AppSizes.spaceBtwSections.h,
                ),

                //Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => AppNavigator.push(
                          context,
                          SuccessPage(
                            image: AppImages.success,
                            title: AppTexts.accountSuccessTitle,
                            subTitle: AppTexts.accountSuccessSubTitle,
                            onPressed: () => AppNavigator.push(context, const LoginPage()),
                          )),
                      child: const Text(AppTexts.aContinue)),
                ),
                SizedBox(
                  height: AppSizes.spaceBtwItems.h,
                ),

                //Button resend
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(AppTexts.resendEmail)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
