import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:blood_bridge/features/emergency/presentation/cubit/emergency_state.dart';
import 'package:blood_bridge/features/emergency/presentation/views/confirm_emergency_view.dart';
import 'package:blood_bridge/features/emergency/presentation/widgets/blood_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// First screen of the emergency flow: pick the needed blood type.
///
/// Expects an [EmergencyCubit] to already be provided above it (see
/// [EmergencyFlowView]) so state survives navigation to the next screens.
class EmergencyView extends StatelessWidget {
  const EmergencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Emergency',
          style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<EmergencyCubit, EmergencyState>(
        builder: (context, state) {
          if (state is! EmergencySelecting) {
            // Shouldn't normally happen since this is the entry screen,
            // but guards against a stale state after navigating back.
            return const SizedBox.shrink();
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.warning_amber_rounded, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Instant Notification',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select blood type needed',
                        style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      BloodTypeSelector(
                        bloodTypes: context.read<EmergencyCubit>().availableBloodTypes,
                        selected: state.selectedBloodType,
                        onSelected: (type) => context.read<EmergencyCubit>().selectBloodType(type),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state.selectedBloodType == null
                          ? null
                          : () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ConfirmEmergencyView()),
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.likeprimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(color: AppColors.primaryForeground, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
