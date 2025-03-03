import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/navigation/navigation_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/navigation/navigation_state.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/home/home.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/search/search.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  static final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    Container(
      color: Colors.pink,
    ),
    Container(
      color: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final darkMode = AppHelperFunctions.isDarkMode(context);

    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
        return Scaffold(
          body: _pages[state.selectedIndex],
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
              },
              destinations: const [
                NavigationDestination(icon: Icon(Iconsax.home), label: 'Trang chủ'),
                NavigationDestination(icon: Icon(Iconsax.search_normal), label: 'Tra số'),
                NavigationDestination(
                    icon: Icon(Iconsax.heart), label: 'Đơn hàng'),
                NavigationDestination(
                    icon: Icon(Iconsax.user), label: 'Giới thiệu'),
              ]),
        );
      }),
    );
  }
}
