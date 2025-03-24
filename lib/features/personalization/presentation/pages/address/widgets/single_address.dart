import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';

class SingleAddress extends StatelessWidget {
  const SingleAddress({super.key, required this.selectedAddress});
  final bool selectedAddress;
  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      width: double.infinity,
      showBorder: true,
      backgroundColor: selectedAddress
          ? AppColors.primary.withOpacity(0.5)
          : AppColors.transparent,
      borderColor: selectedAddress
          ? AppColors.transparent
          : AppHelperFunctions.isDarkMode(context)
              ? AppColors.darkerGrey
              : AppColors.grey,
      padding: EdgeInsets.all(AppSizes.md.r),
      margin: EdgeInsets.only(bottom: AppSizes.spaceBtwItems.h),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Icon(
              selectedAddress ? Iconsax.tick_circle5 : null,
              color: selectedAddress
                  ? AppHelperFunctions.isDarkMode(context)
                      ? AppColors.light
                      : AppColors.dark
                  : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thuan',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: AppSizes.sm.h / 2,
              ),
              const Text(
                '(+84) 345 417 969',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: AppSizes.sm.h / 2,
              ),
              const Text(
                'Ấp Hòa Thịnh, Xã Hòa Bình Thạnh, Huyện Châu Thành, Tỉnh An Giang',
                softWrap: true,
              )
            ],
          )
        ],
      ),
    );
  }
}
