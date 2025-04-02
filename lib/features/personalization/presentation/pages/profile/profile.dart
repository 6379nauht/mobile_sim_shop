import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile/profile_bloc.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/profile/widgets/delete_confirmation_dialog.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/profile/widgets/profile_menu.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/profile/widgets/update_field_dialog.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/profile/widgets/update_name_dialog.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/profile/widgets/update_phone_dialog.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/profile/widgets/update_birth_date_picker.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';

import '../../blocs/profile/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: Text('Tài khoản'), showBackArrow: true),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Đã xảy ra lỗi')),
            );
          } else if (state.status == ProfileStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cập nhật thành công')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.user != null) {
            return _buildProfileContent(context, state.user!);
          }
          return const Center(child: Text('Không có dữ liệu người dùng'));
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.defaultSpace.w),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.blue,
                    backgroundImage: user.profilePicture.isNotEmpty
                        ? NetworkImage(user.profilePicture)
                        : null,
                    child: user.profilePicture.isEmpty
                        ? const Icon(Icons.person, size: 40, color: Colors.white)
                        : null,
                  ),
                  TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => UpdateFieldDialog(user: user, field: 'profilePicture'),
                    ),
                    child: const Text('Thay đổi ảnh đại diện'),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.spaceBtwItems.h / 2),
            const Divider(),
            SizedBox(height: AppSizes.spaceBtwItems.h),
            const SectionHeading(title: 'Thông tin tài khoản', showActionButton: false),
            SizedBox(height: AppSizes.spaceBtwItems.h),
            ProfileMenu(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => UpdateNameDialog(user: user),
              ),
              title: 'Tên',
              value: user.fullName.isEmpty ? 'Chưa đặt' : user.fullName,
            ),
            ProfileMenu(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => UpdateFieldDialog(user: user, field: 'username'),
              ),
              title: 'Username',
              value: user.username.isEmpty ? 'Chưa đặt' : user.username,
            ),
            SizedBox(height: AppSizes.spaceBtwItems.h / 2),
            const Divider(),
            SizedBox(height: AppSizes.spaceBtwItems.h),
            const SectionHeading(title: 'Thông tin cá nhân', showActionButton: false),
            SizedBox(height: AppSizes.spaceBtwItems.h),
            ProfileMenu(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: user.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã sao chép ID: ${user.id}')),
                );
              },
              title: 'User ID',
              value: user.id,
              icon: Iconsax.copy,
            ),
            ProfileMenu(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: user.email));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã sao chép Email: ${user.email}')),
                );
              },
              title: 'Email',
              value: user.email.isEmpty ? 'Chưa đặt' : user.email,
              icon: Iconsax.copy,
            ),
            ProfileMenu(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => UpdatePhoneDialog(user: user),
              ),
              title: 'Số điện thoại',
              value: user.formattedPhoneNo.isEmpty ? 'Chưa đặt' : user.formattedPhoneNo,
            ),
            ProfileMenu(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => UpdateFieldDialog(user: user, field: 'gender'),
              ),
              title: 'Giới tính',
              value: user.gender ?? 'Chưa đặt',
            ),
            ProfileMenu(
              onPressed: () => UpdateBirthDatePicker.show(context, user),
              title: 'Ngày sinh',
              value: user.birthDate ?? 'Chưa đặt',
            ),
            const Divider(),
            SizedBox(height: AppSizes.spaceBtwItems.h),
            Center(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return const DeleteConfirmationDialog(); // Sử dụng widget mới
                    },
                  );
                },
                child: const Text('Xóa tài khoản', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}