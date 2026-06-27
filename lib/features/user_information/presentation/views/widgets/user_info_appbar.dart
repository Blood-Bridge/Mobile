import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:blood_bridge/features/user_information/presentation/cubit/info_cubit.dart';
import 'package:blood_bridge/firebase/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class UserInfoAppBar extends StatelessWidget {
  UserInfoAppBar({
    super.key,
    required this.width,
    required this.height,
    required this.cubit,
  });

  final double width;
  final double height;
  final InfoCubit cubit;

  List<String> mainText = [
    "Personal Information",
    "Contact & Location",
    "Medical Information",
  ];

  List<String> subText = [
    "Tell us about yourself",
    "How can we reach you?",
    "Important health details",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.2,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 2)),
      ),
      child: Padding(
        padding: EdgeInsets.all(width * .03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (cubit.i != 0) {
                      cubit.setI(cubit.i - 1);
                    } else {
                      context.read<AuthCubit>().logout(context);
                      Get.back();
                    }
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.textMuted,
                    size: width * 0.05,
                  ),
                ),
                Spacer(),
                Text(
                  "step ${cubit.i + 1}/3",
                  style: TextStyleHelper.small(context),
                ),
              ],
            ),

            SizedBox(height: height * 0.02),

            LinearProgressIndicator(
              backgroundColor: AppColors.border,
              value: (cubit.i + 1) / 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),

            SizedBox(height: height * 0.02),

            Text(mainText[cubit.i], style: TextStyleHelper.h1(context)),

            Text(subText[cubit.i], style: TextStyleHelper.bodyMuted(context)),
          ],
        ),
      ),
    );
  }
}
