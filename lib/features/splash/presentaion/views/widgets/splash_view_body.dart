import 'package:blood_bridge/core/utiles/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    //excuteNavigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [SvgPicture.asset(Assets.imagesBloodIcon)],
    );
  }

  //   void excuteNavigation() {
  //     bool isOnBoardingViewSeen = Prefs.getBool('kIsOnBoardingViewSeen');
  //     Future.delayed(const Duration(seconds: 3), () {
  //       if (isOnBoardingViewSeen) {
  //         Navigator.pushReplacementNamed(context, LoginView.routeName);
  //       } else {
  //         Navigator.pushReplacementNamed(context, OnBoardingView.routeName);
  //       }
  //     });
  //   }
}
