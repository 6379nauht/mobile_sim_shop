import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/core/helpers/helper_functions.dart';
import 'package:mobile_sim_shop/core/utils/constants/colors.dart';

class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    this.controller, // Thêm controller làm thuộc tính tùy chọn
  });

  final List<Widget> tabs;
  final TabController? controller; // Thuộc tính để nhận TabController

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? AppColors.black : AppColors.white,
      child: TabBar(
        controller: controller, // Sử dụng controller được truyền vào
        padding: EdgeInsets.zero, // Loại bỏ padding của TabBar
        labelPadding: EdgeInsets.symmetric(horizontal: 16.w), // Padding đều nhau
        indicatorSize: TabBarIndicatorSize.label, // Indicator chỉ dưới text
        tabAlignment: TabAlignment.start,
        tabs: tabs,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        labelColor: dark ? AppColors.white : AppColors.primary,
        unselectedLabelColor: AppColors.darkerGrey,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}