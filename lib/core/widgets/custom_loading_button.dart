import 'package:blood_bridge/core/models/user_role.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingButton extends StatelessWidget {
  const CustomLoadingButton({
    super.key,
    required this.isEnabled,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.userType,
    required this.height,
    required this.width,
    required this.toDo,
    required this.text,
  });
  final bool isEnabled;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final UserRole? userType;
  final double height;
  final double width;
  final Function toDo;
  final String text;
  @override
  Widget build(BuildContext context) {
    return isEnabled
        ? CustomButton(
            onPressed: () {
              if (formKey.currentState!.validate() && isEnabled) {
                toDo();
              }
            },
            text: text,
            height: height * 0.07,
            backgroundColor:
                emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty
                ? AppColors.primary
                : AppColors.likeprimary,
          )
        : Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.primary,
              size: width * 0.1,
            ),
          );
  }
}
