import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/circular_container.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:mobile_sim_shop/core/widgets/list_tiles/settings_menu_tile.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';

import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../widgets/user_profile_tile.dart';

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

                ///Profile tile
                UserProfileTile(
                  onPressed: () =>
                    context.pushNamed(Routes.profileName),
                ),
                SizedBox(
                  height: AppSizes.spaceBtwSections.h,
                ),
              ],
            )),

            ///Body
            Padding(
              padding: EdgeInsets.all(AppSizes.defaultSpace.w),
              child: Column(
                children: [
                  ///Account settings
                  const SectionHeading(
                    title: 'Cài đặt tài khoản',
                    showActionButton: false,
                  ),
                  SizedBox(
                    height: AppSizes.spaceBtwItems.h,
                  ),

                  const SettingsMenuTile(
                      icon: Iconsax.safe_home,
                      title: 'Địa chỉ',
                      subTitle: 'Cập nhật hoặc thêm địa chỉ nhận hàng'),
                  const SettingsMenuTile(
                      icon: Iconsax.shopping_cart,
                      title: 'Đơn hàng',
                      subTitle: 'Xem lịch sử mua hàng'),
                  const SettingsMenuTile(
                      icon: Iconsax.bag_tick,
                      title: 'Sản phẩm đã mua',
                      subTitle: 'Danh sách các mặt hàng đã đặt'),
                  const SettingsMenuTile(
                      icon: Iconsax.bank,
                      title: 'Phương thức thanh toán',
                      subTitle: 'Thêm hoặc cập nhật thẻ ngân hàng'),
                  const SettingsMenuTile(
                      icon: Iconsax.discount_shape,
                      title: 'Khuyến mãi',
                      subTitle: 'Xem và áp dụng mã giảm giá'),
                  const SettingsMenuTile(
                      icon: Iconsax.notification,
                      title: 'Thông báo',
                      subTitle: 'Quản lý cài đặt thông báo'),
                  const SettingsMenuTile(
                      icon: Iconsax.security_card,
                      title: 'Bảo mật tài khoản',
                      subTitle: 'Cập nhật mật khẩu & bảo mật'),

                  ///App Settings
                  SizedBox(
                    height: AppSizes.spaceBtwSections.h,
                  ),
                  const SectionHeading(
                    title: 'Cài đặt & Tùy chỉnh',
                    showActionButton: false,
                  ),

                  const SettingsMenuTile(
                      icon: Iconsax.document_upload,
                      title: 'Tải dữ liệu',
                      subTitle: 'Cập nhật dữ liệu hệ thống'),

                  SettingsMenuTile(
                    icon: Iconsax.location,
                    title: 'Vị trí',
                    subTitle: 'Cập nhật quyền truy cập vị trí',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                  SettingsMenuTile(
                    icon: Iconsax.security_user,
                    title: 'Bảo mật',
                    subTitle: 'Quản lý quyền riêng tư',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                  SettingsMenuTile(
                    icon: Iconsax.image,
                    title: 'Hình ảnh',
                    subTitle: 'Cho phép truy cập thư viện ảnh',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),

                  ///Sign out Button
                  SizedBox(
                    height: AppSizes.spaceBtwSections.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {}, child: const Text('Đăng xuất')),
                  ),
                  SizedBox(
                    height: AppSizes.spaceBtwSections.h * 2.5,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
