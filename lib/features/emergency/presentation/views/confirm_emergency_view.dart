import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:blood_bridge/features/emergency/presentation/cubit/emergency_state.dart';
import 'package:blood_bridge/features/emergency/presentation/views/finding_donors_view.dart';
import 'package:blood_bridge/features/emergency/presentation/widgets/emergency_summary_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Second screen of the emergency flow: review the selected blood
/// type and location, then send the alert.
class ConfirmEmergencyView extends StatelessWidget {
  const ConfirmEmergencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Confirm Emergency',
          style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocConsumer<EmergencyCubit, EmergencyState>(
        listener: (context, state) {
          if (state is EmergencySearching) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FindingDonorsView()),
            );
          } else if (state is EmergencyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.destructive),
            );
          }
        },
        builder: (context, state) {
          final isSending = state is EmergencySending;

          // Pull the last known selection so this screen still renders
          // correctly while EmergencySending/EmergencyError are active.
          final selecting = state is EmergencySelecting ? state : null;
          final bloodType = selecting?.selectedBloodType ?? '-';
          final location = selecting?.location ?? 'Current location';

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      EmergencySummaryTile(
                        icon: Icons.bloodtype,
                        label: 'Blood Type',
                        value: bloodType,
                        highlighted: true,
                      ),
                      const EmergencySummaryTile(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        value: 'Current location',
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.destructive.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.destructive.withOpacity(0.4)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.destructive, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Emergency Alert',
                                    style: TextStyle(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'All nearby donors will be notified immediately',
                                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isSending
                              ? null
                              : () => context.read<EmergencyCubit>().sendEmergencyAlert(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.destructive,
                            disabledBackgroundColor: AppColors.likeprimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: isSending
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryForeground),
                                )
                              : const Text(
                                  'Send Emergency Alert',
                                  style: TextStyle(color: AppColors.primaryForeground, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: isSending ? null : () => Navigator.pop(context),
                        style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
                        child: const Text('Back'),
                      ),
                    ],
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
