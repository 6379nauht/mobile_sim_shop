import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/remove_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_bloc.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_event.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_state.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/address/widgets/single_address.dart';

class UserAddressPage extends StatelessWidget {
  const UserAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state.status == AddressStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Có lỗi xảy ra')),
          );
        }
      },
      builder: (context, state) {
        if (state.status == AddressStatus.loading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state.user != null) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.pushNamed(Routes.addNewAddressName, extra: state.user!.id),
              backgroundColor: AppColors.primary,
              child: const Icon(Iconsax.add, color: AppColors.white),
            ),
            appBar: AppAppBar(
              showBackArrow: true,
              title: Text(
                'Địa chỉ',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.defaultSpace.r),
                child: Column(
                  children: state.addresses.isNotEmpty
                      ? state.addresses.map((address) {
                    return Dismissible(
                      key: Key(address.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        context.read<AddressBloc>().add(
                          RemoveAddressEvent(
                            RemoveAddressParams(
                              userId: state.user!.id,
                              addressId: address.id,
                            ),
                          ),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.r),
                        child: const Icon(Iconsax.trash, color: Colors.white),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (!address.selectedAddress) {
                            context.read<AddressBloc>().add(
                              SelectAddressEvent(state.user!.id, address.id),
                            );
                          }
                        },
                        child: SingleAddress(
                          selectedAddress: address.selectedAddress,
                          address: address,
                          user: state.user ?? UserModel.empty(),
                        ),
                      ),
                    );
                  }).toList()
                      : [
                    const Center(child: Text('Chưa có địa chỉ nào')),
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: Text('Không có dữ liệu')));
      },
    );
  }
}