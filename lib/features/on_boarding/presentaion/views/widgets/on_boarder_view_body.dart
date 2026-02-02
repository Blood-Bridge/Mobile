import 'package:blood_bridge/core/services/shared_prefrences_singelton.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/features/auth/presentation/views/login_view.dart';
import 'package:blood_bridge/features/on_boarding/presentaion/views/widgets/on_boarder_page_view.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

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
      children: [
        Expanded(child: OnBoarderPageView(pageController: pageController)),
        DotsIndicator(
          dotsCount: 2,
          decorator: DotsDecorator(
            activeColor: AppColors.primary,
            color: currentIndex == 1
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
        SizedBox(height: 29),
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
                Prefs.setBool('kIsOnBoardingViewSeen', true);
                Navigator.of(context).pushReplacementNamed(LoginView.routeName);
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
