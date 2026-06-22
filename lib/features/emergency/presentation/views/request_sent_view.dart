import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:blood_bridge/features/emergency/presentation/cubit/emergency_state.dart';
import 'package:blood_bridge/features/emergency/presentation/widgets/success_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Final screen of the emergency flow: confirms the alert was sent
/// and shows how many donors were notified.
class RequestSentView extends StatelessWidget {
  const RequestSentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocBuilder<EmergencyCubit, EmergencyState>(
        builder: (context, state) {
          if (state is! EmergencySent) {
            return const SizedBox.shrink();
          }

          final request = state.request;

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SuccessBadge(),
                      const SizedBox(height: 20),
                      const Text(
                        'Request Sent!',
                        style: TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Emergency alert sent to ${request.donorsAlerted} nearby donors.\n'
                        'You\'ll be notified when someone responds.',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<EmergencyCubit>().reset();
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'View Status',
                            style: TextStyle(color: AppColors.primaryForeground, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
