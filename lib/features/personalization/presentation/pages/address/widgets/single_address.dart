import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';

import '../../../../../../core/router/routes.dart';
import '../../../../data/models/address_model.dart';
// Trong SingleAddress, thêm nút chỉnh sửa
class SingleAddress extends StatelessWidget {
  final bool selectedAddress;
  final AddressModel address;
  final UserModel user;
  const SingleAddress({super.key, required this.selectedAddress, required this.address, required this.user});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      width: double.infinity,
      showBorder: true,
      backgroundColor: selectedAddress ? AppColors.primary.withOpacity(0.5) : AppColors.transparent,
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
          Positioned(
            right: 15,
            top: 0,
            child: IconButton(
              icon: const Icon(Iconsax.edit),
              onPressed: () {
                context.pushNamed(
                  Routes.editAddressName,
                  extra: {
                    'userId': user.id,
                    'address': address,
                  },
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: AppSizes.sm.h / 2),
              Text(
                address.phoneNumber,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizes.sm.h / 2),
              Text(
                address.fullAddress,
                softWrap: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}