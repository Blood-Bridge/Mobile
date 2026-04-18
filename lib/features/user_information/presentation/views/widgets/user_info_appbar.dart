import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoAppBar extends StatelessWidget {
  UserInfoAppBar({
    super.key,
    required this.width,
    required this.height,
    required this.i,
  });

  final double width;
  final double height;
  final int i;
  bool isEnabled = false;

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
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.textMuted,
                    size: width * 0.05,
                  ),
                ),
                Spacer(),
                Text("step $i/3", style: TextStyleHelper.small(context)),
              ],
            ),
            SizedBox(height: height * 0.02),
            LinearProgressIndicator(
              backgroundColor: AppColors.border,
              value: i / 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: height * 0.02),
            Text("Personal Information", style: TextStyleHelper.h1(context)),
            Text(
              "Tell us about yourself",
              style: TextStyleHelper.bodyMuted(context),
            ),
          ],
        ),
      ),
    );
  }
}
