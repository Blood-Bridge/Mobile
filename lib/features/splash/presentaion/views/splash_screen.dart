import 'dart:async';

import 'package:blood_bridge/core/models/user_role.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/services/secure_storage_service.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/features/auth/presentation/views/login_screen.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/donor_screen.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/receiver_screen.dart';
import 'package:blood_bridge/features/on_boarding/presentaion/views/on_boarder_view.dart';
import 'package:blood_bridge/features/welcome/presentation/views/welcome_view.dart';
import 'package:blood_bridge/features/user_information/presentation/views/user_info_screen.dart';
import 'package:blood_bridge/features/hospital_dashboard/presentation/views/hospital_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scale = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Timer(const Duration(milliseconds: 2500), () async {
      if (!mounted) return;
      await _navigate();
    });
  }

  Future<void> _navigate() async {
    final onboardingDone = HiveHelper.checkOnBoardingValue();

    if (!onboardingDone) {
      Get.offAll(() => const OnBoarderView());
      return;
    }

    final token = await SecureStorageService.getToken();

    if (token == null || token.isEmpty) {
      Get.offAll(() => const WelcomeView());
      return;
    }

    // Token exists — check if profile is completed
    final name = HiveHelper.getUserName();
    print("name is -------------$name");
    if (name == null || name.trim().isEmpty) {
      // Profile not completed yet — send to UserInfoScreen
      Get.offAll(
        () => const UserInfoScreen(),
        transition: Transition.topLevel,
        duration: const Duration(milliseconds: 400),
      );
      return;
    }

    // Token exists and profile completed — route to home screen by persisted role
    final roleStr = HiveHelper.getUserRole(); // lowercase
    final role = UserRole.fromString(roleStr);

    switch (role) {
      case UserRole.donor:
        Get.offAll(
          () => const DonorScreen(),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
        break;
      case UserRole.recipient:
        Get.offAll(
          () => const ReceiverScreen(),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
        break;
      case UserRole.hospital:
        Get.offAll(
          () => const HospitalDashboardScreen(),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
        break;
      default:
        // Token exists but no role persisted — send to login
        Get.offAll(() => LoginScreen());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
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
