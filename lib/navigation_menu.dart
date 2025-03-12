import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/navigation/navigation_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/navigation/navigation_state.dart';

import 'core/router/routes.dart';

class NavigationMenu extends StatelessWidget {
  final Widget child;

  const NavigationMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final darkMode = AppHelperFunctions.isDarkMode(context);
    // Lấy vị trí hiện tại
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = Routes.all.contains(location)
        ? Routes.all.indexOf(location)
        : 0;

    return BlocProvider(
      create: (context) => NavigationBloc()..add(ChangeTabEvent(index: selectedIndex)),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: child,
            bottomNavigationBar: NavigationBar(
              height: 80.h,
              elevation: 0,
              backgroundColor: darkMode
                  ? AppHelperFunctions.getColor('black')
                  : AppHelperFunctions.getColor('white'),
              indicatorColor: darkMode
                  ? AppColors.white.withOpacity(0.1)
                  : AppColors.black.withOpacity(0.1),
              selectedIndex: state.selectedIndex,
              onDestinationSelected: (index) {
                context.read<NavigationBloc>().add(ChangeTabEvent(index: index));
                context.go(Routes.all[index]);
              },
              destinations: const [
                NavigationDestination(icon: Icon(Iconsax.home), label: 'Trang chủ'),
                NavigationDestination(icon: Icon(Iconsax.shop), label: 'Cửa hàng'),
                NavigationDestination(
                    icon: Icon(Iconsax.heart), label: 'Yêu thích'),
                NavigationDestination(
                    icon: Icon(Iconsax.user), label: 'Tài khoản'),
              ],
            ),
          );
        },
      ),
    );
  }
}