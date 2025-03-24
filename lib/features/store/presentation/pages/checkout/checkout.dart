import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/cart/widgets/list_cart_items.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/checkout/widgets/billing_address_section.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/checkout/widgets/billing_payments_section.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/checkout/widgets/billing_amount_section.dart';

import '../../../../../core/router/routes.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        showBackArrow: true,
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListCartItems(
                showAddRemoveButton: false,
              ),
              SizedBox(
                height: AppSizes.spaceBtwSections.h,
              ),

              ///Coupon text field
              RoundedContainer(
                showBorder: true,
                backgroundColor: AppHelperFunctions.isDarkMode(context)
                    ? AppColors.dark
                    : AppColors.white,
                padding: EdgeInsets.only(
                    top: AppSizes.sm.h,
                    bottom: AppSizes.sm.h,
                    right: AppSizes.sm.w,
                    left: AppSizes.md.w),
                child: Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Have a promo code? Enter here!!',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    )),
                    SizedBox(
                        width: 80.w,
                        child: ElevatedButton(
                            onPressed: () {}, style: ElevatedButton.styleFrom(
                          foregroundColor: AppHelperFunctions.isDarkMode(context) ? AppColors.white.withOpacity(0.5) : AppColors.dark.withOpacity(0.5),
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          side: BorderSide(color: Colors.grey.withOpacity(0.1))
                        ),child: const Text('Apply'))),
                  ],
                ),
              ),
              SizedBox(
                height: AppSizes.spaceBtwSections.h,
              ),
              ///Tax fee
              RoundedContainer(
                showBorder: true,
                padding: EdgeInsets.all(AppSizes.md.r),
                backgroundColor: AppHelperFunctions.isDarkMode(context) ? AppColors.black : AppColors.white,
                child:Column(
                  children: [
                    ///Pricing
                    const BillingAmountSection(),
                    SizedBox(height: AppSizes.spaceBtwItems.h,),

                    ///Divider
                    SizedBox(height: AppSizes.spaceBtwItems.h,),

                    ///Payment Method
                    const BillingPaymentsSection(),
                    SizedBox(height: AppSizes.spaceBtwItems.h,),

                    ///Address
                    const BillingAddressSection(),
                    SizedBox(height: AppSizes.spaceBtwItems.h,),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppSizes.defaultSpace.r),
        child: ElevatedButton(
            onPressed: () => context.pushNamed(Routes.checkoutSuccessName), child: const Text('Thanh toán: 12.444.333VND')),
      ),
    );
  }
}
