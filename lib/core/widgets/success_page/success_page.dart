import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/constants/sizes.dart';
import '../../../core/utils/constants/text_strings.dart';
import '../../styles/spacing_styles.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onPressed});

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: AppSpacingStyles.paddingWithAppBarHeight * 2,
            child: Column(
              children: [
                //Image
                Image(
                  image: AssetImage(image),
                  width: AppSizes.imageWidth.sw,
                ),
                SizedBox(
                  height: AppSizes.spaceBtwSections.h,
                ),

                //Title & SubTitle
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: AppSizes.spaceBtwItems.h,
                ),

                Text(
                  subTitle,
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
                      onPressed: onPressed,
                      child: const Text(AppTexts.aContinue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
