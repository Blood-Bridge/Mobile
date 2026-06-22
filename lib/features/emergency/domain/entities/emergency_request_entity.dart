/// Domain entity representing an emergency blood request submission.
class EmergencyRequestEntity {
  const EmergencyRequestEntity({
    required this.id,
    required this.bloodType,
    required this.location,
    required this.alertRadiusKm,
    required this.donorsAlerted,
    required this.donorsConfirmed,
    required this.status,
  });

  final String id;
  final String bloodType;
  final String location;
  final double alertRadiusKm;
  final int donorsAlerted;
  final int donorsConfirmed;
  final EmergencyRequestStatus status;

  EmergencyRequestEntity copyWith({
    String? id,
    String? bloodType,
    String? location,
    double? alertRadiusKm,
    int? donorsAlerted,
    int? donorsConfirmed,
    EmergencyRequestStatus? status,
  }) {
    return EmergencyRequestEntity(
      id: id ?? this.id,
      bloodType: bloodType ?? this.bloodType,
      location: location ?? this.location,
      alertRadiusKm: alertRadiusKm ?? this.alertRadiusKm,
      donorsAlerted: donorsAlerted ?? this.donorsAlerted,
      donorsConfirmed: donorsConfirmed ?? this.donorsConfirmed,
      status: status ?? this.status,
    );
  }
}

enum EmergencyRequestStatus { draft, searching, sent }
