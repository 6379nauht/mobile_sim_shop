import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/address/widgets/single_address.dart';

class UserAddressPage extends StatelessWidget {
  const UserAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(Routes.addNewAddressName),
        backgroundColor: AppColors.primary,
        child: const Icon(
          Iconsax.add,
          color: AppColors.white,
        ),
      ),
      appBar: AppAppBar(
        showBackArrow: true,
        title: Text(
          'Địa chỉ',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(AppSizes.defaultSpace.r),
        child: const Column(
          children: [
            SingleAddress(selectedAddress: false),
            SingleAddress(selectedAddress: true),
          ],
        ),
        ),
      ),
    );
  }
}
