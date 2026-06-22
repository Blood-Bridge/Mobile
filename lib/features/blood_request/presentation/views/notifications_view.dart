import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/blood_request/data/repositories/blood_request_repository_mock.dart';
import 'package:blood_bridge/features/blood_request/presentation/cubit/notifications_cubit.dart';
import 'package:blood_bridge/features/blood_request/presentation/cubit/notifications_state.dart';
import 'package:blood_bridge/features/blood_request/presentation/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Notifications feed screen, with a "Clear All" action in the AppBar.
///
/// Provides [RequestNotificationsCubit] scoped to this screen. Swap
/// `BloodRequestRepositoryMock()` for `BloodRequestRepositoryImpl()`
/// once the backend endpoints are ready — no other code needs to change.
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestNotificationsCubit(BloodRequestRepositoryMock())..loadNotifications(),
      child: const _NotificationsBody(),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => context.read<RequestNotificationsCubit>().clearAll(),
            child: const Text('Clear All', style: TextStyle(color: AppColors.primary, fontSize: 12)),
          ),
        ],
      ),
      body: BlocBuilder<RequestNotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading || state is NotificationsInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is NotificationsError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: AppColors.textMuted)),
            );
          }

          final notifications = (state as NotificationsLoaded).notifications;

          if (notifications.isEmpty) {
            return const Center(
              child: Text('No notifications', style: TextStyle(color: AppColors.textMuted)),
            );
          }

          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) => NotificationTile(notification: notifications[index]),
            ),
          );
        },
      ),
    );
  }
}
