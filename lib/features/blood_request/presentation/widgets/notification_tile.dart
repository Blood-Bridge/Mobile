import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/blood_request/domain/entities/blood_request_entity.dart';
import 'package:blood_bridge/features/blood_request/presentation/widgets/urgency_badge.dart';
import 'package:flutter/material.dart';

/// A single row in the notifications feed. Visual style adapts to
/// [NotificationEntity.type] (blood request / accepted / reminder).
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification});

  final NotificationEntity notification;

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.bloodRequest:
        return Icons.bloodtype;
      case NotificationType.requestAccepted:
        return Icons.check_circle_outline;
      case NotificationType.donationReminder:
        return Icons.water_drop_outlined;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.bloodRequest:
        return AppColors.primary;
      case NotificationType.requestAccepted:
        return AppColors.success;
      case NotificationType.donationReminder:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final highlight = notification.type == NotificationType.bloodRequest && !notification.isRead;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primary.withOpacity(0.08) : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: highlight ? AppColors.primary.withOpacity(0.4) : AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, size: 20, color: _iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (notification.urgency != null) UrgencyBadge(urgency: notification.urgency!),
                  ],
                ),
                const SizedBox(height: 2),
                Text(notification.subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(height: 4),
                Text(notification.detail, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
