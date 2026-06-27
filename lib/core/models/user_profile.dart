class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String bloodType;
  final String governorate;
  final String nationalId;
  final double weight;
  final String medicalHistory;
  final String dateOfBirth;
  final String role;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.bloodType,
    required this.governorate,
    required this.nationalId,
    required this.weight,
    required this.medicalHistory,
    required this.dateOfBirth,
    required this.role,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final fullName = (json['fullName'] ?? '').toString().trim();
    final parts = fullName.split(' ');

    return UserProfile(
      firstName: json['firstName'] ?? (parts.isNotEmpty ? parts.first : ''),

      lastName:
          json['lastName'] ??
          (parts.length > 1 ? parts.sublist(1).join(' ') : ''),

      email: json['email'] ?? '',
      phone: json['phone'] ?? json['phoneNumber'] ?? '',
      bloodType: json['bloodType'] ?? 'OPositive',
      governorate: json['governorate'] ?? json['location'] ?? '',
      nationalId: json['nationalId'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 70.0,
      medicalHistory: json['medicalHistory'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
