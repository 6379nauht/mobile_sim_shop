import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => SizedBox(
        height: AppSizes.spaceBtwItems.h,
      ),
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (_, index) => RoundedContainer(
        showBorder: true,
        padding: EdgeInsets.all(AppSizes.md.r),
        backgroundColor: AppHelperFunctions.isDarkMode(context)
            ? AppColors.dark
            : AppColors.light,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main container layout changed to column
            Column(
              children: [
                // First row - Order status and number
                Row(
                  children: [
                    // Order status section
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Iconsax.ship),
                          SizedBox(width: AppSizes.spaceBtwItems.w / 2),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Đang xử lý',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                          color: AppColors.primary,
                                          fontWeightDelta: 1),
                                ),
                                Text(
                                  '07 Nov 2024',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Iconsax.arrow_right_34,
                                size: AppSizes.iconSm.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.spaceBtwItems.h),

                // Second row - Order number and delivery date
                Row(
                  children: [
                    // Order number section
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Iconsax.tag),
                          SizedBox(width: AppSizes.spaceBtwItems.w / 2),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Đơn hàng',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                          color: AppColors.primary,
                                          fontWeightDelta: 1),
                                ),
                                Text(
                                  '[#23445F32]',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Delivery date section
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Iconsax.calendar),
                          SizedBox(width: AppSizes.spaceBtwItems.w / 2),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngày giao hàng',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                          color: AppColors.primary,
                                          fontWeightDelta: 1),
                                ),
                                Text(
                                  '09 Nov 2025',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
