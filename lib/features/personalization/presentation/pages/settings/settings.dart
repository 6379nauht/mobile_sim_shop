import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/circular_container.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/primary_header_container.dart';

import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppPrimaryHeaderContainer(
                child: Column(
              children: [
                AppAppBar(
                  title: Text(
                    'Tài khoản',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: AppColors.white),
                  ),
                ),
                SizedBox(height: AppSizes.spaceBtwSections.h,),
                ListTile(
                  leading: CircleAvatar()
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
