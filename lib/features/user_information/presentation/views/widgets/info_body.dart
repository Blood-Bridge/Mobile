import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/features/user_information/presentation/cubit/info_cubit.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/first_info_screen.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/hospital_first_info_screen.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/hospital_third_info_screen.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/second_info_screen.dart';
import 'package:blood_bridge/features/user_information/presentation/views/widgets/third_info_screen.dart';
import 'package:flutter/material.dart';

class InfoBody extends StatelessWidget {
  const InfoBody({
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
    required this.licenseController,
    required this.capacityController,
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
  final TextEditingController licenseController;
  final TextEditingController capacityController;
  final InfoCubit cubit;

  bool get _isHospital => HiveHelper.getUserRole()!.toLowerCase() == 'hospital';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: SingleChildScrollView(child: _buildStep()),
    );
  }

  Widget _buildStep() {
    if (_isHospital) {
      // ── Hospital flow ──────────────────────────────────────────────────
      if (i == 0) {
        return HospitalFirstInfoScreen(
          height: height,
          width: width,
          nameController: nameController,
          licenseController: licenseController,
          cubit: cubit,
        );
      } else if (i == 1) {
        // Step 2 is shared (phone + address + city)
        return SecondInfoScreen(
          height: height,
          phoneController: phoneController,
          width: width,
          addressController: addressController,
          cubit: cubit,
        );
      } else {
        return HospitalThirdInfoScreen(
          height: height,
          width: width,
          capacityController: capacityController,
          cubit: cubit,
        );
      }
    } else {
      // ── Donor / Recipient flow ─────────────────────────────────────────
      if (i == 0) {
        return FirstInfoScreen(
          height: height,
          nameController: nameController,
          nationalIDController: nationalIdController,
          width: width,
          cubit: cubit,
        );
      } else if (i == 1) {
        return SecondInfoScreen(
          height: height,
          phoneController: phoneController,
          width: width,
          addressController: addressController,
          cubit: cubit,
        );
      } else {
        return ThirdInfoScreen(
          height: height,
          width: width,
          weightController: weightController,
          medicalController: medicalController,
          cubit: cubit,
        );
      }
    }
  }
}
