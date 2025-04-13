// lib/features/store/presentation/pages/checkout/widgets/billing_amount_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/utils/validators/validation.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_state.dart';

class BillingAmountSection extends StatelessWidget {
  const BillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // Tính subtotal từ giỏ hàng
        final subtotal = state.cartItems.fold<double>(
          0,
              (sum, item) => sum + (item.price * item.quantity),
        );

        // Giả lập phí vận chuyển và thuế (có thể thay bằng logic thực tế)
        const shippingFee = 2000.0; // Phí vận chuyển cố định
        const taxFee = 1000.0; // Thuế cố định

        // Tổng tiền = subtotal + shippingFee + taxFee
        final orderTotal = subtotal + shippingFee + taxFee;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  AppValidator.formatPrice(subtotal),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            SizedBox(height: AppSizes.spaceBtwSections.h / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping fee', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  AppValidator.formatPrice(shippingFee),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            SizedBox(height: AppSizes.spaceBtwSections.h / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  AppValidator.formatPrice(taxFee),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            SizedBox(height: AppSizes.spaceBtwSections.h / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order total', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  AppValidator.formatPrice(orderTotal),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}