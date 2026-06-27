import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/features/on_boarding/presentaion/views/widgets/on_boarder_page_view.dart';
import 'package:blood_bridge/features/welcome/presentation/views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  late PageController pageController;
  var currentIndex = 0;
  @override
  void initState() {
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentIndex = pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: OnBoarderPageView(pageController: pageController)),
        SizedBox(height: height * 0.05),

        Padding(
          padding: EdgeInsets.only(left: width * 0.4, right: width * 0.4),
          child: Row(
            children: List.generate(
              2,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: currentIndex == i ? width * 0.1 : width * 0.02,
                decoration: BoxDecoration(
                  color: currentIndex == i
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),

        Visibility(
          visible: currentIndex == 1 ? true : false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),

            child: CustomButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                HiveHelper.setValueInOnboardingBox();
                Get.offAll(() => WelcomeView());
              },
              text: 'Get Started',
            ),
          ),
        ),
        SizedBox(height: 29),
      ],
    );
  }
}
