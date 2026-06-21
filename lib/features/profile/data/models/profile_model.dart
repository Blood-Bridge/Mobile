import 'package:blood_bridge/features/profile/domain/entities/profile_entity.dart';

/// Data-layer model for the donor profile.
///
/// Handles JSON (de)serialization for the API/cache and converts
/// to/from the domain [ProfileEntity].
class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.location,
    required super.bloodType,
    required super.verifiedSince,
    required super.emergencyNotificationsEnabled,
    required super.locationSharingEnabled,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
      bloodType: json['blood_type'] as String,
      verifiedSince: DateTime.parse(json['verified_since'] as String),
      emergencyNotificationsEnabled:
          json['emergency_notifications_enabled'] as bool? ?? false,
      locationSharingEnabled:
          json['location_sharing_enabled'] as bool? ?? false,
    );
  }

  /// Builds a [ProfileModel] from a domain entity (used before sending
  /// updates back to the API).
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      location: entity.location,
      bloodType: entity.bloodType,
      verifiedSince: entity.verifiedSince,
      emergencyNotificationsEnabled: entity.emergencyNotificationsEnabled,
      locationSharingEnabled: entity.locationSharingEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'blood_type': bloodType,
      'verified_since': verifiedSince.toIso8601String(),
      'emergency_notifications_enabled': emergencyNotificationsEnabled,
      'location_sharing_enabled': locationSharingEnabled,
    };
  }
}
