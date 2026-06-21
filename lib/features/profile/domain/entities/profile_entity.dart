/// Domain entity representing a donor's profile.
///
/// This is the pure business object used across the app, independent
/// of any JSON/Hive/network concerns (those live in [ProfileModel]).
class ProfileEntity {
  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.bloodType,
    required this.verifiedSince,
    required this.emergencyNotificationsEnabled,
    required this.locationSharingEnabled,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String bloodType;
  final DateTime verifiedSince;
  final bool emergencyNotificationsEnabled;
  final bool locationSharingEnabled;

  ProfileEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? bloodType,
    DateTime? verifiedSince,
    bool? emergencyNotificationsEnabled,
    bool? locationSharingEnabled,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bloodType: bloodType ?? this.bloodType,
      verifiedSince: verifiedSince ?? this.verifiedSince,
      emergencyNotificationsEnabled:
          emergencyNotificationsEnabled ?? this.emergencyNotificationsEnabled,
      locationSharingEnabled:
          locationSharingEnabled ?? this.locationSharingEnabled,
    );
  }
}
