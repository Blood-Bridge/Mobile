import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:blood_bridge/core/models/user_role.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_images.dart';
import 'package:blood_bridge/features/auth/presentation/views/login_screen.dart';
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
      setState(() {
        selectedRole = null;
      });

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
        Get.to(
          () => LoginScreen(userType: UserRole.donor),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
        break;
      case UserRole.recipient:
        Get.to(
          () => LoginScreen(userType: UserRole.recipient),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
        break;
      case UserRole.hospital:
        Get.to(
          () => LoginScreen(userType: UserRole.hospital),
          transition: Transition.topLevel,
          duration: const Duration(milliseconds: 400),
        );
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
                  AppLocalizations.of(context)!.welcome,
                  style: TextStyleHelper.h1(context),
                ),

                const SizedBox(height: 8),

                Text(
                  AppLocalizations.of(context)!.howWouldYouLikeTo,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.small(context),
                ),

                SizedBox(height: height * 0.06),

                AnimatedContainer(
                  transformAlignment: AlignmentGeometry.directional(0, 50),
                  duration: const Duration(milliseconds: 400),
                  child: RoleCard(
                    icon: SvgPicture.asset(Assets.imagesBloodTypeIcon),
                    title: AppLocalizations.of(context)!.donateBlood,
                    subtitle: 'Help save lives by donating blood',
                    isSelected: selectedRole == UserRole.donor,
                    onTap: () => _onRoleTap(UserRole.donor),
                  ),
                ),

                RoleCard(
                  icon: SvgPicture.asset(Assets.imagesFavoriteIcon),
                  title: AppLocalizations.of(context)!.requestBlood,
                  subtitle: 'Find donors in your area',
                  isSelected: selectedRole == UserRole.recipient,
                  onTap: () => _onRoleTap(UserRole.recipient),
                ),

                RoleCard(
                  icon: SvgPicture.asset(Assets.imagesHospitalIcon),
                  title: AppLocalizations.of(context)!.hospital,
                  subtitle: 'Manage blood requests',
                  isSelected: selectedRole == UserRole.hospital,
                  onTap: () => _onRoleTap(UserRole.hospital),
                ),

                const Spacer(),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: selectedRole != null ? 1 : 0,
                  child: Text(
                    AppLocalizations.of(context)!.tapAgainToContinue,
                    style: TextStyleHelper.small(context),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
