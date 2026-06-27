import 'package:blood_bridge/features/user_information/presentation/cubit/info_cubit.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/first_info_screen.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/second_info_screen.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/third_info_screen.dart';
import 'package:flutter/material.dart';

class InfoBody extends StatelessWidget {
  InfoBody({
    super.key,
    required this.width,
    required this.height,
    required this.i,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.nationalIdController,
    required this.weightController,
    required this.medicalController,
    required this.cubit,
  });
  final double width;
  final double height;
  final int i;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController nationalIdController;
  final TextEditingController weightController;
  final TextEditingController medicalController;
  final InfoCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: SingleChildScrollView(
        child: i == 0
            ? FirstInfoScreen(
                height: height,
                nameController: nameController,
                nationalIDController: nationalIdController,
                width: width,
                cubit: cubit,
              )
            : i == 1
            ? SecondInfoScreen(
                height: height,
                phoneController: phoneController,
                width: width,
                addressController: addressController,
                cubit: cubit,
              )
            : ThirdInfoScreen(
                height: height,
                width: width,
                weightController: weightController,
                medicalController: medicalController,
                cubit: cubit,
              ),
      ),
    );
  }
}
