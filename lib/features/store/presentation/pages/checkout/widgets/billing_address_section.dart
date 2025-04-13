import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_bloc.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_event.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/cart/cart_state.dart';

class BillingAddressSection extends StatelessWidget {
  const BillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(
          title: 'Shipping Address',
          buttonTitle: 'Change',
          onPressed: () => _showAddressOptions(context),
        ),
        SizedBox(height: AppSizes.spaceBtwItems.h / 2),
        BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            final shippingAddress = cartState.shippingAddress ?? '';
            final shippingPhoneNumber = cartState.shippingPhoneNumber ?? '';
            final userName = cartState.userName ?? '';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: AppSizes.spaceBtwItems.h / 2),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.grey, size: 16.sp),
                    SizedBox(width: AppSizes.spaceBtwItems.w),
                    Text(shippingPhoneNumber,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                SizedBox(height: AppSizes.spaceBtwItems.h / 2),
                Row(
                  children: [
                    Icon(Icons.location_history, color: Colors.grey, size: 16.sp),
                    SizedBox(width: AppSizes.spaceBtwItems.w),
                    Expanded(
                      child: Text(
                        shippingAddress,
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showAddressOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<AddressBloc, AddressState>(
          builder: (context, addressState) {
            if (addressState.status == AddressStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (addressState.addresses.isEmpty) {
              return const Center(child: Text('Chưa có địa chỉ nào'));
            }

            return Padding(
              padding: EdgeInsets.all(AppSizes.defaultSpace.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Select Address',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: addressState.addresses.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final address = addressState.addresses[index];
                        return ListTile(
                          leading: Icon(
                            Icons.circle,
                            color: address.selectedAddress
                                ? AppColors.primary
                                : Colors.grey,
                            size: 20.sp,
                          ),
                          title: Text(
                            address.name,
                            style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${address.phoneNumber}\n${address.fullAddress}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          onTap: () {
                            context.read<AddressBloc>().add(
                              SelectAddressEvent(
                                  addressState.user!.id, address.id),
                            );
                            context.read<CartBloc>().add(
                              ChangeShippingAddressEvent(
                                address.fullAddress,
                                address.phoneNumber,
                                address.name,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections.h,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.pushNamed(
                          Routes.addNewAddressName,
                          extra: addressState.user!.id,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: const Text('Add new address'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}