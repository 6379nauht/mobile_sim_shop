// lib/features/store/presentation/pages/checkout/checkout_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/utils/validators/validation.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/cart/widgets/list_cart_items.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/checkout/widgets/billing_address_section.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/checkout/widgets/billing_amount_section.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/checkout/widgets/billing_payments_section.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        showBackArrow: true,
        title: Text('Order Review', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.defaultSpace.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListCartItems(showAddRemoveButton: false),
              SizedBox(height: AppSizes.spaceBtwSections.h),
              RoundedContainer(
                showBorder: true,
                backgroundColor: AppHelperFunctions.isDarkMode(context)
                    ? AppColors.dark
                    : AppColors.white,
                padding: EdgeInsets.all(AppSizes.md.r),
                child: Column(
                  children: [
                    const BillingAmountSection(),
                    SizedBox(height: AppSizes.spaceBtwItems.h),
                    const BillingPaymentsSection(),
                    SizedBox(height: AppSizes.spaceBtwItems.h),
                    const BillingAddressSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppSizes.defaultSpace.r),
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state.status == CartStatus.success) {
              context.pushNamed(Routes.checkoutSuccessName);
            } else if (state.status == CartStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Payment failed')),
              );
            }
          },
          builder: (context, state) {
            // Tính tổng tiền bao gồm các phí
            final subtotal = state.cartItems.fold<double>(
              0,
                  (sum, item) => sum + (item.price * item.quantity),
            );
            const shippingFee = 2000.0; // Phải khớp với BillingAmountSection
            const taxFee = 1000.0; // Phải khớp với BillingAmountSection
            final totalPrice = subtotal + shippingFee + taxFee;

            final paymentMethod = state.selectedPaymentMethod?.name ?? 'Cash on Delivery';
            return
              ElevatedButton(
              onPressed: state.status == CartStatus.loading
                  ? null
                  : () => context.read<CartBloc>().add(ProcessPaymentEvent(amount: totalPrice)),
              child: state.status == CartStatus.loading
                  ? const CircularProgressIndicator()
                  : Text('Thanh toán: ${AppValidator.formatPrice(totalPrice)}'),
            );
          },
        ),
      ),
    );
  }
}