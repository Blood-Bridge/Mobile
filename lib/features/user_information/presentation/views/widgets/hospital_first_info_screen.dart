import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_textfield.dart';
import 'package:blood_bridge/features/user_information/presentation/cubit/info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HospitalFirstInfoScreen extends StatelessWidget {
  const HospitalFirstInfoScreen({
    super.key,
    required this.height,
    required this.width,
    required this.nameController,
    required this.licenseController,
    required this.cubit,
  });

  final double height;
  final double width;
  final TextEditingController nameController;
  final TextEditingController licenseController;
  final InfoCubit cubit;

  static const List<String> _hospitalTypes = [
    'Government',
    'Private',
    'University',
    'Military',
    'Specialized',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hospital Name *", style: TextStyleHelper.small(context)),
        SizedBox(height: height * 0.01),
        CustomTextfield(
          prefixIcon: const Icon(Icons.local_hospital_outlined),
          text: "Enter hospital name",
          controller: nameController,
          validator: (v) =>
              (v == null || v.isEmpty) ? 'Please enter hospital name' : null,
        ),
        SizedBox(height: height * 0.04),

        Text("License Number *", style: TextStyleHelper.small(context)),
        SizedBox(height: height * 0.01),
        CustomTextfield(
          prefixIcon: const Icon(Icons.badge_outlined),
          text: "e.g. MOH-2024-00123",
          controller: licenseController,
          validator: (v) =>
              (v == null || v.isEmpty) ? 'Please enter license number' : null,
        ),
        SizedBox(height: height * 0.04),

        Text("Hospital Type *", style: TextStyleHelper.small(context)),
        SizedBox(height: height * 0.01),
        BlocBuilder<InfoCubit, InfoState>(
          builder: (context, state) {
            return DropdownButtonFormField<String>(
              dropdownColor: Colors.black,
              value: cubit.hospitalType,
              hint: Text(
                "Select hospital type",
                style: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.white),
              items: _hospitalTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) {
                if (v != null) cubit.setHospitalType(v);
              },
              validator: (v) =>
                  v == null ? 'Please select hospital type' : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
