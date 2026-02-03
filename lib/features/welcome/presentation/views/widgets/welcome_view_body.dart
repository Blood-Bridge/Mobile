import 'package:blood_bridge/core/models/user_role.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/utiles/app_images.dart';
import 'package:blood_bridge/core/utiles/app_text_styles.dart';
import 'package:blood_bridge/features/auth/presentation/views/login_view.dart';
import 'package:blood_bridge/features/welcome/presentation/views/widgets/role_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WelcomeViewBody extends StatefulWidget {
  const WelcomeViewBody({super.key});

  @override
  State<WelcomeViewBody> createState() => _WelcomeViewBodyState();
}

class _WelcomeViewBodyState extends State<WelcomeViewBody> {
  UserRole? selectedRole;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSavedRole();
  }

  void _checkSavedRole() async {
    final savedRole = HiveHelper.getUserRole();

    if (savedRole != null) {
      final role = UserRole.fromString(savedRole);

      if (role != null) {
        Future.microtask(() {
          _navigateByRole(role);
        });
      }
    }
  }

  void _onRoleTap(UserRole role) async {
    HapticFeedback.lightImpact();

    if (selectedRole == role) {
      setState(() => isLoading = true);

      await HiveHelper.saveUserRole(role.displayName);

      await Future.delayed(const Duration(milliseconds: 400));
      _navigateByRole(role);
    } else {
      setState(() {
        selectedRole = role;
      });
    }
  }

  void _navigateByRole(UserRole role) {
    switch (role) {
      case UserRole.donor:
        Get.offAll(() => const LoginView());
        break;
      case UserRole.requester:
        Get.offAll(() => const LoginView());
        break;
      case UserRole.hospital:
        Get.offAll(() => const LoginView());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: height * 0.08),

                Text(
                  'Welcome',
                  style: TextStyles.regular16.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'How would you like to use Blood Bridge?',
                  textAlign: TextAlign.center,
                  style: TextStyles.regular16.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: height * 0.06),

                RoleCard(
                  icon: SvgPicture.asset(Assets.imagesBloodTypeIcon),
                  title: 'Donate Blood',
                  subtitle: 'Help save lives by donating blood',
                  isSelected: selectedRole == UserRole.donor,
                  onTap: () => _onRoleTap(UserRole.donor),
                ),

                RoleCard(
                  icon: SvgPicture.asset(Assets.imagesFavoriteIcon),
                  title: 'Request Blood',
                  subtitle: 'Find donors in your area',
                  isSelected: selectedRole == UserRole.requester,
                  onTap: () => _onRoleTap(UserRole.requester),
                ),

                RoleCard(
                  icon: SvgPicture.asset(Assets.imagesHospitalIcon),
                  title: 'Hospital',
                  subtitle: 'Manage blood requests',
                  isSelected: selectedRole == UserRole.hospital,
                  onTap: () => _onRoleTap(UserRole.hospital),
                ),

                const Spacer(),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: selectedRole != null ? 1 : 0,
                  child: Text(
                    'Tap again to continue',
                    style: TextStyles.regular16.copyWith(
                      color: Colors.grey[500],
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.6),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
