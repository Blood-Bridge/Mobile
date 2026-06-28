import 'dart:math';

import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/models/user_role.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_loading_button.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/core/widgets/custom_textfield.dart';
import 'package:blood_bridge/core/widgets/google_button.dart';
import 'package:blood_bridge/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:blood_bridge/features/user_information/presentation/views/user_info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key, this.userType});
  final UserRole? userType;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    final cubit = context.read<AuthCubit>();
    return SafeArea(
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            Get.to(
              () => UserInfoScreen(),
              transition: Transition.topLevel,
              duration: const Duration(milliseconds: 400),
            );
          } else if (state is LoginFailure) {
            showSnackBar("Failed", state.message, SnackbarType.error);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.all(width * 0.0155),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(width * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.1),

                    Text('Sign Up', style: TextStyleHelper.h1(context)),

                    SizedBox(height: height * 0.02),

                    Text(
                      'Join Blood Bridge to save lives',
                      textAlign: TextAlign.center,
                      style: TextStyleHelper.bodyMuted(context),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      height: height * 0.076,
                      child: CustomTextfield(
                        text: context.l10n.email,
                        controller: emailController,
                        validator: cubit.emailValidator,
                      ),
                    ),

                    SizedBox(height: height * 0.01),

                    Container(
                      height: height * 0.076,
                      child: CustomTextfield(
                        text: context.l10n.password,
                        isPassword: true,
                        controller: passwordController,
                        validator: cubit.passwordValidator,
                      ),
                    ),

                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomLoadingButton(
                          isEnabled: cubit.isEnabled,
                          text: context.l10n.signUp,
                          formKey: _formKey,

                          emailController: emailController,

                          userType: userType,

                          passwordController: passwordController,

                          height: height,

                          width: width,

                          toDo: () => cubit.signUp(
                            email: emailController.text,
                            password: passwordController.text,
                            userType: userType ?? UserRole.donor,
                          ),
                        );
                      },
                    ),

                    SizedBox(height: height * 0.02),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: AppColors.border, thickness: 3),
                        ),
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                          child: Text(
                            'Or continue with',
                            style: TextStyleHelper.bodyMuted(context),
                          ),
                        ),

                        Expanded(
                          child: Divider(color: AppColors.border, thickness: 3),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.02),

                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () => cubit.googleLogin(context),
                          child: GoogleButton(
                            height: height,
                            width: width,
                            isEnabled: cubit.isEnabled,
                          ),
                        );
                      },
                    ),

                    SizedBox(height: height * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyleHelper.body(context),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyleHelper.body(
                              context,
                            ).copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
