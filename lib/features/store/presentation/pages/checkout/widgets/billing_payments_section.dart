// lib/features/store/presentation/pages/checkout/widgets/billing_payments_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/image_strings.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/payment_method.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_event.dart';

import '../../../blocs/cart/cart_state.dart';

class BillingPaymentsSection extends StatelessWidget {
  const BillingPaymentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(LoadPaymentMethod());
    return Column(
      children: [
        SectionHeading(
          title: 'Payment Method',
          buttonTitle: 'Change',
          onPressed: () => _showPaymentOptions(context),
        ),
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final selectedMethod = state.selectedPaymentMethod ??
                PaymentMethod(id: 'cod', name: 'Cash on Delivery');
            return Row(
              children: [
                RoundedContainer(
                  width: 60.w,
                  height: 60.h,
                  backgroundColor: AppHelperFunctions.isDarkMode(context)
                      ? AppColors.light
                      : AppColors.white,
                  padding: EdgeInsets.all(AppSizes.sm.r),
                  child: Image(
                    image: AssetImage(selectedMethod.id == 'cod'
                        ? AppImages.iconCash
                        : AppImages.iconStripe),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: AppSizes.spaceBtwItems.w / 2),
                Text(selectedMethod.name,
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Select PaymentMethod',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              SizedBox(height: AppSizes.spaceBtwItems.h,),
              ListTile(
                leading: const Image(image: AssetImage(AppImages.iconStripe)),
                title: const Text('Stripe'),
                onTap: () {
                  context.read<CartBloc>().add(SelectPaymentMethodEvent(
                      paymentMethod:
                          PaymentMethod(id: 'stripe', name: 'Stripe')));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Image(image: AssetImage(AppImages.iconCash)),
                title: const Text('Cash on Delivery'),
                onTap: () {
                  context.read<CartBloc>().add(SelectPaymentMethodEvent(
                      paymentMethod:
                          PaymentMethod(id: 'cod', name: 'Cash on Delivery')));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
