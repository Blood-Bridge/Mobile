import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/notifications/presentation/cubit/app_notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.foreground,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('Notifications', style: TextStyleHelper.h1(context)),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AppNotificationsCubit>().markAllAsRead();
              Get.snackbar(
                'Notifications',
                'All marked as read',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text(
              'Mark all read',
              style: TextStyleHelper.small(
                context,
              ).copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AppNotificationsCubit, AppNotificationsState>(
        builder: (context, state) {
          if (state is AppNotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AppNotificationsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(state.error, style: TextStyleHelper.body(context)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<AppNotificationsCubit>()
                        .fetchNotifications(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AppNotificationsLoaded) {
            final list = state.notifications;

            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 80,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No notifications yet',
                      style: TextStyleHelper.h2(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You will see updates here',
                      style: TextStyleHelper.bodyMuted(context),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<AppNotificationsCubit>().fetchNotifications(),
              color: AppColors.primary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: item.isRead
                            ? AppColors.border
                            : AppColors.primary.withOpacity(0.3),
                        width: item.isRead ? 1.0 : 1.5,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: item.isRead
                            ? AppColors.muted
                            : AppColors.primary.withOpacity(0.15),
                        child: Icon(
                          Icons.notifications_active,
                          size: 20,
                          color: item.isRead
                              ? AppColors.textMuted
                              : AppColors.primary,
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyleHelper.small(context).copyWith(
                                fontWeight: item.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!item.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            item.message,
                            style: TextStyleHelper.xs(
                              context,
                            ).copyWith(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.createdAt.isEmpty
                                ? ''
                                : item.createdAt.split('T').first,
                            style: TextStyleHelper.xs(context).copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Pull to refresh'));
        },
      ),
    );
  }
}
