import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';

class UpdateBirthDatePicker extends StatelessWidget {
  final UserModel user;

  const UpdateBirthDatePicker({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    DateTime initialDate = _parseInitialDate(user.birthDate);

    return ElevatedButton(
      onPressed: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          final formattedDate = DateFormat('dd MMM, yyyy').format(pickedDate);
          final updatedUser = user.copyWith(birthDate: formattedDate);
          context.read<ProfileBloc>().add(UpdateProfile(user: updatedUser, imageFile: null));
        }
      },
      child: const Text('Update Birth Date'),
    );
  }

  // Hàm phụ để tính initialDate
  DateTime _parseInitialDate(String? birthDate) {
    DateTime initialDate = DateTime.now();
    if (birthDate != null) {
      try {
        initialDate = DateFormat('dd MMM, yyyy').parse(birthDate);
      } catch (e) {
        print('Error parsing birth date: $e');
      }
    }
    return initialDate;
  }

  // Phương thức tĩnh (nếu vẫn cần dùng ở nơi khác)
  static void show(BuildContext context, UserModel user) {
    final initialDate = UpdateBirthDatePicker(user: user)._parseInitialDate(user.birthDate);

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        final formattedDate = DateFormat('dd MMM, yyyy').format(pickedDate);
        final updatedUser = user.copyWith(birthDate: formattedDate);
        context.read<ProfileBloc>().add(UpdateProfile(user: updatedUser, imageFile: null));
      }
    });
  }
}