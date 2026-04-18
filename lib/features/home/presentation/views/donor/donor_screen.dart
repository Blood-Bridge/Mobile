import 'package:blood_bridge/constants.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/utiles/app_images.dart';
import 'package:blood_bridge/core/utiles/extentions.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/widgets/donor_appbar.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/widgets/donor_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DonorScreen extends StatelessWidget {
  const DonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height;
    bool isEnabled = true;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DonorAppBar(width: width, height: height),
            Expanded(
              child: DonorBody(height: height, width: width),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: CustomButton(
                text: 'Profile',
                height: height * 0.08,
                width: width,
                backgroundColor: AppColors.popover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
