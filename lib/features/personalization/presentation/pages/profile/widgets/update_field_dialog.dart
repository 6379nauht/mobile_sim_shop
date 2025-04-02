import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_sim_shop/features/auth/data/models/user_model.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile/profile_bloc.dart';

import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';

class UpdateFieldDialog extends StatefulWidget {
  final UserModel user;
  final String field;

  const UpdateFieldDialog({super.key, required this.user, required this.field});

  @override
  State<UpdateFieldDialog> createState() => _UpdateFieldDialogState();
}

class _UpdateFieldDialogState extends State<UpdateFieldDialog> {
  final TextEditingController controller = TextEditingController();
  String hintText = '';
  String title = '';
  String? selectedGender;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.user.gender;

    switch (widget.field) {
      case 'username':
        controller.text = widget.user.username;
        hintText = 'Nhập username';
        title = 'Cập nhật username';
        break;
      case 'profilePicture':
        controller.text = widget.user.profilePicture;
        hintText = 'Nhập URL ảnh đại diện (hoặc chọn ảnh)';
        title = 'Cập nhật ảnh đại diện';
        break;
      case 'gender':
        title = 'Cập nhật giới tính';
        break;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        controller.clear(); // Xóa URL nếu chọn ảnh từ thiết bị
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_isLoading) return; // Ngăn nhấn "Lưu" nhiều lần

    // Kiểm tra dữ liệu đầu vào
    if (widget.field == 'gender' && selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn giới tính')),
      );
      return;
    }
    if (widget.field != 'gender' && widget.field != 'profilePicture' && controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập giá trị')),
      );
      return;
    }
    if (widget.field == 'profilePicture' && controller.text.isEmpty && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập URL hoặc chọn ảnh')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Tạo UserModel cập nhật
    UserModel updatedUser;
    if (widget.field == 'gender') {
      updatedUser = widget.user.copyWith(gender: selectedGender);
    } else if (widget.field == 'profilePicture') {
      updatedUser = widget.user.copyWith(
        profilePicture: _imageFile == null ? controller.text : null, // Chỉ dùng URL nếu không có ảnh
      );
    } else {
      updatedUser = widget.user.copyWith(
        username: widget.field == 'username' ? controller.text : widget.user.username,
      );
    }

    // Gửi sự kiện và đợi kết quả
    final profileBloc = context.read<ProfileBloc>();
    profileBloc.add(UpdateProfile(user: updatedUser, imageFile: _imageFile));

    // Đợi trạng thái từ ProfileBloc
    await for (final state in profileBloc.stream) {
      if (state.status == ProfileStatus.success) {
        Navigator.pop(context); // Đóng dialog khi thành công
        break;
      } else if (state.status == ProfileStatus.failure) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage ?? 'Cập nhật thất bại')),
        );
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: _isLoading
          ? const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      )
          : widget.field == 'gender'
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: selectedGender,
            hint: const Text('Chọn giới tính'),
            items: ['Nam', 'Nữ'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
        ],
      )
          : widget.field == 'profilePicture'
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_imageFile != null)
            Image.file(_imageFile!, height: 100, fit: BoxFit.cover)
          else if (controller.text.isNotEmpty)
            Image.network(
              controller.text,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Text('Không tải được ảnh'),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Chọn từ thư viện'),
              ),
              TextButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Chụp ảnh'),
              ),
            ],
          ),
        ],
      )
          : TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hintText),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _updateProfile,
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}