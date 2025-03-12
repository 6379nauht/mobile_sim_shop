import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:mobile_sim_shop/core/widgets/text/section_heading.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/profile/widgets/profile_menu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: Text('Tài khoản'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
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
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text('Cập nhật ảnh đại diện'))
                  ],
                ),
              ),

              //Details
              SizedBox(
                height: AppSizes.spaceBtwItems.h / 2,
              ),
              const Divider(),
              SizedBox(
                height: AppSizes.spaceBtwItems.h,
              ),

              ///Heading Profile info
              const SectionHeading(
                title: 'Thông tin tài khoản',
                showActionButton: false,
              ),
              SizedBox(
                height: AppSizes.spaceBtwItems.h,
              ),

              ProfileMenu(
                onPressed: () {},
                title: 'Tên',
                value: 'Nguyễn Minh Thuận',
              ),
              ProfileMenu(
                onPressed: () {},
                title: 'Username',
                value: 'thuan633',
              ),

              SizedBox(
                height: AppSizes.spaceBtwItems.h / 2,
              ),
              const Divider(),
              SizedBox(
                height: AppSizes.spaceBtwItems.h,
              ),

              ///Heading Personal Info
              const SectionHeading(
                title: 'Thông tin cá nhân',
                showActionButton: false,
              ),
              SizedBox(
                height: AppSizes.spaceBtwItems.h,
              ),

              ProfileMenu(
                onPressed: () {},
                title: 'User ID',
                value: '33',
              ),
              ProfileMenu(
                onPressed: () {},
                title: 'Email',
                value: 'thuan633@gmail.com',
              ),
              ProfileMenu(
                onPressed: () {},
                title: 'Số Điện Thoại',
                value: '0345417969',
              ),
              ProfileMenu(
                onPressed: () {},
                title: 'Giới Tính',
                value: 'Nam',
              ),
              ProfileMenu(
                onPressed: () {},
                title: 'Ngày Sinh',
                value: '10 Oct, 2003',
              ),
              const Divider(),
              SizedBox(
                height: AppSizes.spaceBtwItems.h,
              ),

              Center(
                child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Xóa Tài Khoản',
                      style: TextStyle(color: Colors.red),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
