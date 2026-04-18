import 'dart:async';

import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/features/auth/presentation/views/login_screen.dart';
import 'package:blood_bridge/features/on_boarding/presentaion/views/on_boarder_view.dart';
import 'package:blood_bridge/features/on_boarding/presentaion/views/widgets/on_boarder_view_body.dart';
import 'package:blood_bridge/features/welcome/presentation/views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  @override
  void initState() {
    super.initState();

    // Drives the whole splash animation timeline
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fades content from invisible to visible
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Scales content from smaller size to full size with a soft overshoot
    _scale = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Starts the animation immediately
    _controller.forward();

    // Navigates to the next screen after the splash finishes
    Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      if (HiveHelper.checkOnBoardingValue()) {
        if (HiveHelper.getToken() == null) {
          Get.offAll(() => const WelcomeView());
        } else {
          Get.offAll(() => OnBoarderView());
        }
      } else {
        Get.offAll(() => const OnBoarderView());
      }
    });
  }

  @override
  void dispose() {
    // Releases animation resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.bg,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 25),
              blurRadius: 50,
              color: AppColors.card,
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fade.value,
              child: Transform.scale(scale: _scale.value, child: child),
            );
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: width * .5,
                  height: width * .5,
                ),

                const SizedBox(height: 24),

                Text("Blood Bridge", style: TextStyleHelper.h1(context)),

                const SizedBox(height: 12),

                Text(
                  "Connecting lives in emergency",
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.bodyMuted(
                    context,
                  ).copyWith(height: 1.25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
