class HospitalProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String governorate;
  final String address;
  final String licenseNumber;
  final String hospitalType; // e.g. "Government", "Private", "University"
  final int capacity; // total bed capacity
  final bool hasBloodBank;
  final bool isActive;
  final String role;

  HospitalProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.governorate,
    required this.address,
    required this.licenseNumber,
    required this.hospitalType,
    required this.capacity,
    required this.hasBloodBank,
    required this.isActive,
    required this.role,
  });

  factory HospitalProfile.fromJson(Map<String, dynamic> json) {
    return HospitalProfile(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? json['hospitalName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? json['phoneNumber']?.toString() ?? '',
      governorate:
          json['governorate']?.toString() ?? json['location']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      licenseNumber:
          json['licenseNumber']?.toString() ??
          json['license']?.toString() ??
          '',
      hospitalType:
          json['hospitalType']?.toString() ??
          json['type']?.toString() ??
          'General',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      hasBloodBank: json['hasBloodBank'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      role: json['role']?.toString() ?? 'Hospital',
    );
  }
}
