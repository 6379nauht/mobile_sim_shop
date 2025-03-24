import 'dart:io';

import '../../../auth/data/models/user_model.dart';

class UpdateUserParams {
  final UserModel user;
  final File? imageFile;
  UpdateUserParams({required this.user, this.imageFile});
}