import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import '../../../blocs/profile_bloc.dart';
import '../../../blocs/profile_event.dart';

class UpdatePhoneDialog extends StatelessWidget {
  final UserModel user;

  const UpdatePhoneDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController(text: user.phoneNumber);

    return AlertDialog(
      title: const Text('Cập nhật số điện thoại'),
      content: TextField(
        controller: phoneController,
        decoration: const InputDecoration(hintText: 'Nhập số điện thoại'),
        keyboardType: TextInputType.phone,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            if (phoneController.text.isEmpty ||
                !RegExp(r'^\+?[0-9]{9,15}$').hasMatch(phoneController.text)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Số điện thoại không hợp lệ')),
              );
              return;
            }
            final updatedUser = user.copyWith(phoneNumber: phoneController.text);
            context.read<ProfileBloc>().add(UpdateProfile(user: updatedUser));
            Navigator.pop(context);
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}