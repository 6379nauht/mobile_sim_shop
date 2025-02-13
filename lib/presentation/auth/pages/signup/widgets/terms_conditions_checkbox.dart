
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../ common/helpers/helper_functions.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/utils/constants/text_strings.dart';

class TermsAndConditionCheckbox extends StatelessWidget {
  const TermsAndConditionCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);

    return Row(
      children: [
        SizedBox(
          width: AppSizes.defaultSpace.w,
          height: AppSizes.defaultSpace,
          child: Checkbox(value: true, onChanged: (value) {}),
        ),
        SizedBox(
          width: AppSizes.spaceBtwItems.w,
        ),
        Flexible(
          child: Text.rich(TextSpan(children: [
            TextSpan(
                text: '${AppTexts.iAgreeTo} ',
                style: Theme.of(context).textTheme.bodySmall),
            TextSpan(
                text: '${AppTexts.privacyPolicy} ',
                style:
                Theme.of(context).textTheme.bodyMedium!.apply(
                  color: dark
                      ? AppColors.white
                      : AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: dark
                      ? AppColors.white
                      : AppColors.primary,
                )),
            TextSpan(
                text: '${AppTexts.add} ',
                style: Theme.of(context).textTheme.bodySmall),
            TextSpan(
                text: AppTexts.termsOfUse,
                style:
                Theme.of(context).textTheme.bodyMedium!.apply(
                  color: dark
                      ? AppColors.white
                      : AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: dark
                      ? AppColors.white
                      : AppColors.primary,
                )),
          ]),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}