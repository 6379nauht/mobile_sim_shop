
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_sim_shop/features/auth/presentation/blocs/signup/signup_bloc.dart';
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/utils/constants/text_strings.dart';
import 'package:mobile_sim_shop/features/auth/presentation/pages/signup/widgets/terms_conditions_checkbox.dart';
import '../../../../../../core/utils/validators/validation.dart';
import '../../../blocs/signup/signup_event.dart';
import '../../../blocs/signup/signup_state.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // Ẩn/hiện mật khẩu

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            return Column(
              children: [
                // First Name & Last Name
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: AppTexts.firstName,
                          prefixIcon: Icon(Iconsax.user),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'First name is required.'
                            : null,
                        onChanged: (value) => context
                            .read<SignupBloc>()
                            .add(FirstNameChanged(value)),
                      ),
                    ),
                    SizedBox(width: AppSizes.spaceBtwInputFields.w),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: AppTexts.lastName,
                          prefixIcon: Icon(Iconsax.user),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Last name is required.'
                            : null,
                        onChanged: (value) => context
                            .read<SignupBloc>()
                            .add(LastNameChanged(value)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.spaceBtwInputFields.h),

                // Username
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: AppTexts.userName,
                    prefixIcon: Icon(Iconsax.user_edit),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Username is required.'
                      : null,
                  onChanged: (value) =>
                      context.read<SignupBloc>().add(UsernameChanged(value)),
                ),
                SizedBox(height: AppSizes.spaceBtwInputFields.h),

                // Email
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: AppTexts.email,
                    prefixIcon: Icon(Iconsax.direct),
                  ),
                  validator: AppValidator.validateEmail,
                  onChanged: (value) =>
                      context.read<SignupBloc>().add(EmailChanged(value)),
                ),
                SizedBox(height: AppSizes.spaceBtwInputFields.h),

                // Phone Number
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: AppTexts.phoneNumber,
                    prefixIcon: Icon(Iconsax.call),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: AppValidator.validatePhoneNumber,
                  onChanged: (value) =>
                      context.read<SignupBloc>().add(PhoneNumberChanged(value)),
                ),
                SizedBox(height: AppSizes.spaceBtwInputFields.h),

                // Password
                TextFormField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: AppTexts.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: AppValidator.validatePassword,
                  onChanged: (value) =>
                      context.read<SignupBloc>().add(PasswordChanged(value)),
                ),
                SizedBox(height: AppSizes.spaceBtwSections.h),

                // Điều khoản & điều kiện
                const TermsAndConditionCheckbox(),
                SizedBox(height: AppSizes.spaceBtwSections.h),

                // Nút đăng ký
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.status == SignupStatus.loading
                        ? null
                        : () {
                            // Nếu đã đồng ý, thực hiện đăng ký
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<SignupBloc>()
                                  .add(const SignupSubmitted());
                            }
                          },
                    child: state.status == SignupStatus.loading
                        ? const CircularProgressIndicator()
                        : const Text(AppTexts.createAccount),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
