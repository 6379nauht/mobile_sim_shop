import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/popups/loaders.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:mobile_sim_shop/core/widgets/list_tiles/settings_menu_tile.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile_bloc.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile_state.dart';

import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../auth/presentation/blocs/signin/signin_bloc.dart';
import '../../../../auth/presentation/blocs/signin/signin_event.dart';
import '../../../../auth/presentation/blocs/signin/signin_state.dart';
import '../../widgets/user_profile_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninBloc, SigninState>(
      listener: (_, state) {
        if (state.status == SigninStatus.unauthenticated) {
          context.goNamed(Routes.signinName);
        } else if (state.status == SigninStatus.failure &&
            state.errorMessage != null &&
            !state.errorShow) {
          AppLoaders.customSnackbar(
              context: context,
              title: 'Lỗi',
              msg: state.errorMessage,
              contentType: ContentType.failure);
        }
        context.read<SigninBloc>().add(MarkErrorAsShown());
      },
      builder: (_, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return AppPrimaryHeaderContainer(
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

                          /// Profile tile
                          UserProfileTile(
                            name: state.user?.fullName ?? '',
                            email: state.user?.email ?? '',
                            imageUrl: state.user?.profilePicture,
                            onPressed: () => context.pushNamed(Routes.profileName),
                          ),
                          SizedBox(height: AppSizes.spaceBtwSections.h),
                        ],
                      ),
                    );
                  },
                ),

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

                      SettingsMenuTile(
                        icon: Iconsax.safe_home,
                        title: 'Địa chỉ',
                        subTitle: 'Cập nhật hoặc thêm địa chỉ nhận hàng',
                        onTap: () => context.pushNamed(Routes.addressName),
                      ),
                      SettingsMenuTile(
                        icon: Iconsax.shopping_cart,
                        title: 'Đơn hàng',
                        subTitle: 'Xem lịch sử mua hàng',
                        onTap: () => context.pushNamed(Routes.orderName),
                      ),
                      const SettingsMenuTile(
                        icon: Iconsax.bag_tick,
                        title: 'Sản phẩm đã mua',
                        subTitle: 'Danh sách các mặt hàng đã đặt',
                      ),
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
                      // Sign out Button with loading state
                      SizedBox(height: AppSizes.spaceBtwSections.h),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: state.status == SigninStatus.loading
                              ? null // Disable button while loading
                              : () async {
                                  // Lưu SigninBloc trước khi gọi async để tránh dùng context sau async gap
                                  final signinBloc = context.read<SigninBloc>();
                                  final bool? shouldSignOut =
                                      await showDialog<bool>(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      title: const Text('Xác nhận đăng xuất'),
                                      content: const Text(
                                          'Bạn có chắc chắn muốn đăng xuất không?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(dialogContext)
                                                  .pop(false),
                                          child: const Text('Hủy'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(dialogContext)
                                                  .pop(true),
                                          child: const Text('Xác nhận'),
                                        ),
                                      ],
                                    ),
                                  );

                                  // Nếu người dùng xác nhận, gửi SignOutEvent
                                  if (shouldSignOut ?? false) {
                                    signinBloc.add(SignOutEvent());
                                  }
                                },
                          child: state.status == SigninStatus.loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('Đăng xuất'),
                        ),
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
      },
    );
  }
}
