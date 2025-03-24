import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_bloc.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signin/signin_event.dart';

import '../../../../../../core/router/routes.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import '../../../../../../core/utils/constants/text_strings.dart';
import '../../../../../../core/utils/validators/validation.dart';
import '../../../blocs/signin/signin_state.dart';

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
            child: BlocBuilder<SigninBloc, SigninState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppSizes.spaceBtwSections.w),
                  child: Column(
                    children: [
                      //Email
                      TextFormField(
                        initialValue: state.email,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: AppTexts.email,
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
                              onPressed: () => context.pushNamed(Routes.forgetPasswordName),
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
                          onPressed:
                                state.status == SigninStatus.loading
                                    ? null
                                    : () {
                                        // Kiểm tra nếu form hợp lệ thì gửi sự kiện SigninSubmitted
                                        if (_formKey.currentState!.validate()) {
                                          context.read<SigninBloc>().add(const SigninSubmitted());
                                        }
                                      },

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
                              onPressed: () => context.pushNamed(Routes.signupName),
                              child: const Text(AppTexts.createAccount)))
                    ],
                  ),
                );
              },
            ));
  }
}
