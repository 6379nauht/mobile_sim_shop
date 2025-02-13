import 'package:flutter/material.dart';
import 'package:mobile_sim_shop/%20common/helpers/helper_functions.dart';

import '../../../core/utils/constants/colors.dart';

class FormDivider extends StatelessWidget {
  final String text;

  const FormDivider({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: dark ? AppColors.darkerGrey : AppColors.grey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text(
          AppHelperFunctions.capitalizeEachWord(text),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Flexible(
          child: Divider(
            color: dark ? AppColors.darkerGrey : AppColors.grey,
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        ),
      ],
    );
  }
}
