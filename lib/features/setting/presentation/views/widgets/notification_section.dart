import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_state.dart';
import 'package:blood_bridge/features/setting/presentation/views/widgets/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/toggle_item.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return SettingsGroup(
          sectionTitle: 'Notifications',
          children: [
            ToggleItem(
              title: 'Emergency Alerts',
              subtitle: 'Critical blood requests',
              value: state.emergencyAlerts,
              onChanged: (val) =>
                  context.read<NotificationsCubit>().toggleEmergencyAlerts(val),
            ),
            ToggleItem(
              title: 'Request Notifications',
              subtitle: 'Standard blood requests',
              value: state.requestNotifications,
              onChanged: (val) => context
                  .read<NotificationsCubit>()
                  .toggleRequestNotifications(val),
            ),
            ToggleItem(
              title: 'Donation Reminders',
              subtitle: 'When eligible to donate again',
              value: state!.donationReminders,
              onChanged: (val) => context
                  .read<NotificationsCubit>()
                  .toggleDonationReminders(val),
            ),
          ],
        );
      },
    );
  }
}
