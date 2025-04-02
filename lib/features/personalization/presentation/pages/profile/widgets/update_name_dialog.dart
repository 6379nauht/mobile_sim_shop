import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';

class UpdateNameDialog extends StatelessWidget {
  final UserModel user;

  const UpdateNameDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);

    return AlertDialog(
      title: const Text('Cập nhật tên'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: firstNameController,
            decoration: const InputDecoration(hintText: 'Nhập họ'),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: lastNameController,
            decoration: const InputDecoration(hintText: 'Nhập tên'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vui lòng nhập cả họ và tên')),
              );
              return;
            }
            final updatedUser = user.copyWith(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
            );
            context.read<ProfileBloc>().add(UpdateProfile(user: updatedUser));
            Navigator.pop(context);
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}