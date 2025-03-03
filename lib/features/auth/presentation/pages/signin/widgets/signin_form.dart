import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_event.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/pages/settings/settings.dart';
import '../../../../../../core/navigators/navigator.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import '../../../../../../core/utils/constants/text_strings.dart';
import '../../../../../../core/utils/validators/validation.dart';
import '../../../blocs/signin/signin_state.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/signup.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // Ẩn/hiện mật khẩu

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: BlocListener<SigninBloc, SigninState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == SigninStatus.initial) {
                context.read<SigninBloc>().add(LoadRememberMe());
              } else if (state.status == SigninStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đăng nhập thành công!")),
                );
              } else if (state.status == SigninStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đăng nhập thất bại!")),
                );
              }
            },
            child: BlocBuilder<SigninBloc, SigninState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppSizes.spaceBtwSections.w),
                  child: Column(
                    children: [
                      //Email
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.direct_right),
                          labelText: state.email,
                        ),
                        validator: AppValidator.validateEmail,
                        onChanged: (value) =>
                            context.read<SigninBloc>().add(EmailChanged(value)),
                      ),
                      SizedBox(
                        height: AppSizes.spaceBtwInputFields.h,
                      ),

                      // Password
                      TextFormField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: AppTexts.password,
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: AppValidator.validatePassword,
                        onChanged: (value) => context
                            .read<SigninBloc>()
                            .add(PasswordChanged(value)),
                      ),
                      SizedBox(
                        height: AppSizes.spaceBtwInputFields.h / 2,
                      ),

                      //Remember Me & Forget Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Remember Me
                          Row(
                            children: [
                              Checkbox(
                                value: state.value,
                                onChanged: (value) {
                                  context
                                      .read<SigninBloc>()
                                      .add(ToggleRememberMe(value ?? false));
                                },
                              ),
                              const Text(AppTexts.rememberMe),
                            ],
                          ),

                          //forget password
                          TextButton(
                              onPressed: () => AppNavigator.push(
                                  context, const ForgetPassword()),
                              child: const Text(AppTexts.forgetPassword)),
                        ],
                      ),
                      SizedBox(
                        height: AppSizes.spaceBtwSections.h,
                      ),

                      //Sign in button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: /*
                                state.status == SigninStatus.loading
                                    ? null
                                    : () {
                                        // Kiểm tra nếu form hợp lệ thì gửi sự kiện SigninSubmitted
                                        if (_formKey.currentState!.validate()) {
                                          context.read<SigninBloc>().add(const SigninSubmitted());
                                        }
                                      };
                                */
                              () => AppNavigator.push(
                                  context, const SettingsPage()),
                          child: state.status == SigninStatus.loading
                              ? const CircularProgressIndicator()
                              : const Text(AppTexts.signIn),
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.spaceBtwItems.h,
                      ),

                      //create account button
                      SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                              onPressed: () => AppNavigator.push(
                                  context, const SignupPage()),
                              child: const Text(AppTexts.createAccount)))
                    ],
                  ),
                );
              },
            )));
  }
}
