
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/utils/constants/colors.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          radius: 40.r,
          backgroundColor: Colors.blue,
        ),
        title: Text(
          'Thuan',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: AppColors.white),
        ),
        subtitle: Text(
          'thuan@gmail.com',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .apply(color: AppColors.white),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Iconsax.edit,
            color: AppColors.white,
          ),
        ));
  }
}