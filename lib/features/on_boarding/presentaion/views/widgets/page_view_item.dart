import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/features/welcome/presentation/views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    this.backgroundImage,
    required this.title,
    required this.subTitle,
  });

  final String image;
  final String? backgroundImage;
  final Widget title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: height * 0.4,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SvgPicture.asset(image),
              ),

              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      HiveHelper.setValueInOnboardingBox();
                      Get.offAll(() => WelcomeView());
                      // Navigate to login or home screen
                    },
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.06),
                      child: Text(
                        'skip',
                        style: TextStyleHelper.small(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: height * 0.05),
        title,
        SizedBox(height: height * 0.05),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .05),
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.bodyMuted(context),
          ),
        ),
      ],
    );
  }
}
