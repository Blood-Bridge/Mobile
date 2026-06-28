import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_textfield.dart';
import 'package:blood_bridge/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    _emailController = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.foreground,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          context.l10n.resetPassword,
          style: TextStyleHelper.h1(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.04),
                Text(
                  context.l10n.askForToken,
                  style: TextStyleHelper.bodyMuted(context),
                ),
                SizedBox(height: height * 0.04),
                CustomTextfield(
                  text: context.l10n.emailAddress,
                  controller: _emailController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Email is required' : null,
                ),
                SizedBox(height: height * 0.02),
                CustomTextfield(
                  text: context.l10n.resetToken,
                  controller: _tokenController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Token is required' : null,
                ),
                SizedBox(height: height * 0.02),
                CustomTextfield(
                  text: context.l10n.newPassword,
                  controller: _passwordController,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 8)
                      return 'Password must be at least 8 characters';
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                CustomTextfield(
                  text: context.l10n.confirmNewPassword,
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Confirm password is required';
                    if (v != _passwordController.text)
                      return 'Passwords do not match';
                    return null;
                  },
                ),
                SizedBox(height: height * 0.06),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is LoginLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().resetPassword(
                                    email: _emailController.text,
                                    token: _tokenController.text,
                                    newPassword: _passwordController.text,
                                    confirmPassword:
                                        _confirmPasswordController.text,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                context.l10n.resetPassword,
                                style: TextStyleHelper.h3(
                                  context,
                                ).copyWith(color: AppColors.primaryForeground),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
