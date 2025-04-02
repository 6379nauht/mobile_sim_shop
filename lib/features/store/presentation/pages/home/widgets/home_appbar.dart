
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile/profile_bloc.dart';

import '../../../../../../core/utils/constants/colors.dart';
import '../../../../../../core/utils/constants/text_strings.dart';
import '../../../../../../core/widgets/appbar/appbar.dart';
import '../../../../../../core/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../personalization/presentation/blocs/profile/profile_state.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.homeAppBarTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: AppColors.grey),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (_, state) {
              return Text(
                state.user?.fullName ?? '',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .apply(color: AppColors.light),
              );
            },
          )
        ],
      ),
      actions: [
        CartCounterIcon(
          iconColor: AppColors.light,
          onPressed: () => context.pushNamed(Routes.cartName),
        )
      ],
    );
  }
}
