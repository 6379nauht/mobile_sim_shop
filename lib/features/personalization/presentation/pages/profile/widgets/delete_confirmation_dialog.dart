import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile_bloc.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile_event.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/profile_state.dart';

import '../../../../../auth/presentation/blocs/signin/signin_bloc.dart';
import '../../../../../auth/presentation/blocs/signin/signin_event.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  State<DeleteConfirmationDialog> createState() => _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isGoogleSignIn = false;

  @override
  void initState() {
    super.initState();
    _checkSignInMethod();
  }

  void _checkSignInMethod() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _isGoogleSignIn = user.providerData.any((info) => info.providerId == 'google.com');
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận xóa tài khoản'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isGoogleSignIn
                ? 'Vui lòng đăng nhập lại bằng Google để xác nhận:'
                : 'Vui lòng nhập mật khẩu để xác nhận:',
          ),
          const SizedBox(height: 10),
          if (!_isGoogleSignIn)
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Nhập mật khẩu',
                border: OutlineInputBorder(),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.unauthenticated) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tài khoản đã được xóa thành công')),
              );
              context.read<SigninBloc>().add(SignOutEvent());
              Future.delayed(const Duration(milliseconds: 300), () {
                context.goNamed(Routes.signinName);
              });
            } else if (state.status == ProfileStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return const CircularProgressIndicator();
            }
            return TextButton(
              onPressed: () {
                if (_isGoogleSignIn) {
                  context.read<ProfileBloc>().add(const DeleteAccountEvent(password: null));
                } else {
                  final password = _passwordController.text.trim();
                  if (password.isNotEmpty) {
                    context.read<ProfileBloc>().add(DeleteAccountEvent(password: password));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng nhập mật khẩu')),
                    );
                  }
                }
              },
              child: Text(
                _isGoogleSignIn ? 'Đăng nhập Google' : 'Xóa',
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      ],
    );
  }
}