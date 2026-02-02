import 'package:blood_bridge/core/services/shared_prefrences_singelton.dart';
import 'package:blood_bridge/core/utiles/app_images.dart';
import 'package:blood_bridge/core/utiles/app_text_styles.dart';
import 'package:blood_bridge/features/auth/presentation/views/login_view.dart';
import 'package:blood_bridge/features/on_boarding/presentaion/views/on_boarder_view.dart';
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
    super.initState();
    excuteNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(flex: 2),
          SvgPicture.asset(Assets.imagesBloodIcon),
          Spacer(flex: 1),
          Text('Blood Bridge', style: TextStyles.regular30),
          Spacer(flex: 1),
          Text(
            'Connecting lives in emergency',
            style: TextStyles.regular16.copyWith(
              color: const Color(0xFFA3A3A3),
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  void excuteNavigation() {
    bool isOnBoardingViewSeen = Prefs.getBool('kIsOnBoardingViewSeen');
    print('isOnBoardingViewSeen: $isOnBoardingViewSeen'); // Debug print
    Future.delayed(const Duration(seconds: 3), () {
      if (isOnBoardingViewSeen) {
        Navigator.pushReplacementNamed(context, LoginView.routeName);
      } else {
        Navigator.pushReplacementNamed(context, OnBoarderView.routeName);
      }
    });
  }
}
