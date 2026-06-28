import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_textfield.dart';
import 'package:blood_bridge/features/user_information/presentation/cubit/info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HospitalThirdInfoScreen extends StatelessWidget {
  const HospitalThirdInfoScreen({
    super.key,
    required this.height,
    required this.width,
    required this.capacityController,
    required this.cubit,
  });

  final double height;
  final double width;
  final TextEditingController capacityController;
  final InfoCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Total Bed Capacity *", style: TextStyleHelper.small(context)),
        SizedBox(height: height * 0.01),
        CustomTextfield(
          prefixIcon: const Icon(Icons.bed_outlined),
          text: "e.g. 300",
          controller: capacityController,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please enter capacity';
            final n = int.tryParse(v);
            if (n == null || n <= 0) return 'Please enter a valid number';
            return null;
          },
        ),
        SizedBox(height: height * 0.04),

        Text("Blood Bank *", style: TextStyleHelper.small(context)),
        SizedBox(height: height * 0.02),
        BlocBuilder<InfoCubit, InfoState>(
          builder: (context, state) {
            return Row(
              children: [
                // Yes
                Expanded(
                  child: GestureDetector(
                    onTap: () => cubit.setHasBloodBank(true),
                    child: Container(
                      height: height * 0.07,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        border: Border.all(
                          color: cubit.hasBloodBank == true
                              ? AppColors.primary
                              : AppColors.border,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: cubit.hasBloodBank == true
                                ? AppColors.primary
                                : AppColors.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Available",
                            style: TextStyleHelper.small(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.03),
                // No
                Expanded(
                  child: GestureDetector(
                    onTap: () => cubit.setHasBloodBank(false),
                    child: Container(
                      height: height * 0.07,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        border: Border.all(
                          color: cubit.hasBloodBank == false
                              ? AppColors.primary
                              : AppColors.border,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: cubit.hasBloodBank == false
                                ? AppColors.primary
                                : AppColors.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Not Available",
                            style: TextStyleHelper.small(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: height * 0.04),

        // Info card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'This information helps donors and patients find the right facility for their needs.',
                  style: TextStyleHelper.small(
                    context,
                  ).copyWith(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
