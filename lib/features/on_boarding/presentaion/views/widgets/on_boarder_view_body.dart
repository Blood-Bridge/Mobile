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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: OnBoarderPageView(pageController: pageController)),

        /// 🔵 Animated Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: currentIndex == i ? 24 : 8,
              decoration: BoxDecoration(
                color: currentIndex == i
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),

        const SizedBox(height: 29),

        /// 🔘 Get Started Button
        Visibility(
          visible: currentIndex == 1,
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
              onPressed: () async {
                await HiveHelper.setOnboardingCompleted();
                Get.offAll(() => WelcomeView());
              },
              text: 'Get Started',
            ),
          ),
        ),

        const SizedBox(height: 29),
      ],
    );
  }
}
