import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import '../../../blocs/profile_bloc.dart';
import '../../../blocs/profile_event.dart';
class UpdateBirthDatePicker extends StatelessWidget {
  final UserModel user;

  const UpdateBirthDatePicker({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    DateTime initialDate = DateTime.now();
    if (user.birthDate != null) {
      try {
        initialDate = DateFormat('dd MMM, yyyy').parse(user.birthDate!);
      } catch (_) {}
    }

    return Builder(
      builder: (context) => Container(), // Widget này chỉ để gọi showDatePicker
    );
  }

  static void show(BuildContext context, UserModel user) {
    DateTime initialDate = DateTime.now();
    if (user.birthDate != null) {
      try {
        initialDate = DateFormat('dd MMM, yyyy').parse(user.birthDate!);
      } catch (_) {}
    }

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