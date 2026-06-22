import 'package:blood_bridge/features/blood_request/domain/entities/blood_request_entity.dart';

class BloodRequestModel extends BloodRequestEntity {
  const BloodRequestModel({
    required super.id,
    required super.bloodType,
    required super.ward,
    required super.hospitalName,
    required super.distanceKm,
    required super.requestedAt,
    required super.quantityUnits,
    required super.urgency,
    required super.location,
    required super.expiresAt,
  });

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
    return BloodRequestModel(
      id: json['id'] as String,
      bloodType: json['blood_type'] as String,
      ward: json['ward'] as String,
      hospitalName: json['hospital_name'] as String,
      distanceKm: (json['distance_km'] as num).toDouble(),
      requestedAt: DateTime.parse(json['requested_at'] as String),
      quantityUnits: json['quantity_units'] as int,
      urgency: _urgencyFromString(json['urgency'] as String?),
      location: json['location'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  static RequestUrgency _urgencyFromString(String? value) {
    switch (value) {
      case 'critical':
        return RequestUrgency.critical;
      case 'urgent':
        return RequestUrgency.urgent;
      default:
        return RequestUrgency.normal;
    }
  }
}

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.subtitle,
    required super.detail,
    required super.createdAt,
    required super.isRead,
    super.urgency,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: _typeFromString(json['type'] as String?),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      detail: json['detail'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
      urgency: json['urgency'] != null ? _urgencyFromString(json['urgency'] as String) : null,
    );
  }

  static NotificationType _typeFromString(String? value) {
    switch (value) {
      case 'request_accepted':
        return NotificationType.requestAccepted;
      case 'donation_reminder':
        return NotificationType.donationReminder;
      default:
        return NotificationType.bloodRequest;
    }
  }

  static RequestUrgency _urgencyFromString(String value) {
    switch (value) {
      case 'critical':
        return RequestUrgency.critical;
      case 'urgent':
        return RequestUrgency.urgent;
      default:
        return RequestUrgency.normal;
    }
  }
}
