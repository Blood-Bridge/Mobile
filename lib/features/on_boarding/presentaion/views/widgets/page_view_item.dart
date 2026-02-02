import 'package:blood_bridge/core/services/shared_prefrences_singelton.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/utiles/app_text_styles.dart';
import 'package:blood_bridge/features/auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    this.backgroundImage,
    required this.title,
    required this.subTitle,
  });

  final String image;
  final String? backgroundImage;
  final Widget title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SvgPicture.asset(image),
              ),

              GestureDetector(
                onTap: () {
                  Prefs.setBool('kIsOnBoardingViewSeen', true);
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(LoginView.routeName);
                  // Navigate to login or home screen
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'skip',
                    style: TextStyles.regular16.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 65),
        title,
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regular20.copyWith(
              color: const Color(0xFF4E5456),
            ),
          ),
        ),
      ],
    );
  }
}
