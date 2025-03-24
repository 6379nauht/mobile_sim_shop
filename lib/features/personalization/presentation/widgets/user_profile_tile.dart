import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/utils/constants/colors.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key,
    required this.onPressed,
    required this.name,
    required this.email,
    this.imageUrl, // Thêm tham số cho URL ảnh (có thể là null)
  });

  final VoidCallback onPressed;
  final String name;
  final String email;
  final String? imageUrl; // URL của ảnh đại diện, có thể là null

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 40.r,
        backgroundColor: Colors.blue, // Màu nền mặc định nếu không có ảnh
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? NetworkImage(imageUrl!) // Hiển thị ảnh từ URL nếu có
            : null,
        child: imageUrl == null || imageUrl!.isEmpty
            ? const Icon(
          Iconsax.user,
          size: 40,
          color: AppColors.white,
        ) // Hiển thị icon mặc định nếu không có ảnh
            : null,
      ),
      title: Text(
        name,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: AppColors.white),
      ),
      subtitle: Text(
        email,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .apply(color: AppColors.white),
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Iconsax.edit,
          color: AppColors.white,
        ),
      ),
    );
  }
}