/// Domain entity for a single blood request that a donor can
/// accept or decline (the "Emergency Request" detail screen).
class BloodRequestEntity {
  const BloodRequestEntity({
    required this.id,
    required this.bloodType,
    required this.ward,
    required this.hospitalName,
    required this.distanceKm,
    required this.requestedAt,
    required this.quantityUnits,
    required this.urgency,
    required this.location,
    required this.expiresAt,
  });

  final String id;
  final String bloodType;
  final String ward;
  final String hospitalName;
  final double distanceKm;
  final DateTime requestedAt;
  final int quantityUnits;
  final RequestUrgency urgency;
  final String location;

  /// When this request offer expires (countdown shown on screen).
  final DateTime expiresAt;
}

enum RequestUrgency { normal, urgent, critical }

/// Domain entity for a single notification item in the
/// notifications feed.
class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.createdAt,
    required this.isRead,
    this.urgency,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String subtitle;
  final String detail;
  final DateTime createdAt;
  final bool isRead;

  /// Only relevant for [NotificationType.bloodRequest].
  final RequestUrgency? urgency;

  NotificationEntity copyWith({bool? isRead}) {
    return NotificationEntity(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      detail: detail,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      urgency: urgency,
    );
  }
}

enum NotificationType { bloodRequest, requestAccepted, donationReminder }
