import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/cubit/cubit/donor_cubit.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/widgets/donor_appbar.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/widgets/donor_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/features/profile/presentation/views/profile_screen.dart';
import 'package:get/get.dart';

class DonorScreen extends StatelessWidget {
  const DonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final cubit = context.read<DonorCubit>();
    return Scaffold(
      body: SafeArea(
        child: AbsorbPointer(
          absorbing: cubit.isLoading,
          child: Column(
            children: [
              DonorAppBar(width: width, height: height, cubit: cubit),
              Expanded(
                child: DonorBody(height: height, width: width, cubit: cubit),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: CustomButton(
                  text: 'Profile',
                  height: height * 0.08,
                  width: width,
                  backgroundColor: AppColors.popover,
                  onPressed: () => Get.to(() => const ProfileScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
