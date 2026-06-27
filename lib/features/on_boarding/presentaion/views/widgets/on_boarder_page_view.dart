import 'package:blood_bridge/core/utiles/app_images.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/features/on_boarding/presentaion/views/widgets/page_view_item.dart';
import 'package:flutter/material.dart';

class OnBoarderPageView extends StatelessWidget {
  const OnBoarderPageView({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          image: Assets.imagesDropIcon,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Connect Lives Instantly ',
                style: TextStyleHelper.h2(context),
              ),
            ],
          ),
          subTitle:
              'Real-time matching with nearby blood donors in emergency situations',
        ),
        // items duplicated for testing purpose
        PageViewItem(
          image: Assets.imagesRingIcon,
          title: Text(
            ' Save Lives Together',
            style: TextStyleHelper.h2(context),
          ),
          subTitle:
              'Real-time matching with nearby blood donors in emergency situations',
        ),
      ],
    );
  }
}
