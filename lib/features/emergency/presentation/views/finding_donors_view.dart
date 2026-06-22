import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:blood_bridge/features/emergency/presentation/cubit/emergency_state.dart';
import 'package:blood_bridge/features/emergency/presentation/views/request_sent_view.dart';
import 'package:blood_bridge/features/emergency/presentation/widgets/finding_donors_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Third screen of the emergency flow: shown while the backend
/// searches for and notifies nearby donors. Listens to
/// [EmergencyCubit]'s donor-search stream and auto-navigates to
/// [RequestSentView] once the search completes.
class FindingDonorsView extends StatelessWidget {
  const FindingDonorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocConsumer<EmergencyCubit, EmergencyState>(
        listener: (context, state) {
          if (state is EmergencySent) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RequestSentView()),
            );
          } else if (state is EmergencyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.destructive),
            );
          }
        },
        builder: (context, state) {
          final donorsAlerted = state is EmergencySearching ? state.request.donorsAlerted : 0;

          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FindingDonorsAnimation(),
                    const SizedBox(height: 32),
                    const Text(
                      'Finding Donors',
                      style: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      donorsAlerted > 0
                          ? 'Notifying nearby A+ donors ($donorsAlerted alerted)'
                          : 'Notifying nearby A+ donors',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
