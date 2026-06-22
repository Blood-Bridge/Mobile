import 'package:blood_bridge/features/emergency/domain/entities/emergency_request_entity.dart';

/// Data-layer model for an emergency request, including JSON mapping.
class EmergencyRequestModel extends EmergencyRequestEntity {
  const EmergencyRequestModel({
    required super.id,
    required super.bloodType,
    required super.location,
    required super.alertRadiusKm,
    required super.donorsAlerted,
    required super.donorsConfirmed,
    required super.status,
  });

  factory EmergencyRequestModel.fromJson(Map<String, dynamic> json) {
    return EmergencyRequestModel(
      id: json['id'] as String,
      bloodType: json['blood_type'] as String,
      location: json['location'] as String,
      alertRadiusKm: (json['alert_radius_km'] as num).toDouble(),
      donorsAlerted: json['donors_alerted'] as int,
      donorsConfirmed: json['donors_confirmed'] as int,
      status: _statusFromString(json['status'] as String?),
    );
  }

  static EmergencyRequestStatus _statusFromString(String? value) {
    switch (value) {
      case 'searching':
        return EmergencyRequestStatus.searching;
      case 'sent':
        return EmergencyRequestStatus.sent;
      default:
        return EmergencyRequestStatus.draft;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blood_type': bloodType,
      'location': location,
      'alert_radius_km': alertRadiusKm,
      'donors_alerted': donorsAlerted,
      'donors_confirmed': donorsConfirmed,
      'status': status.name,
    };
  }
}
