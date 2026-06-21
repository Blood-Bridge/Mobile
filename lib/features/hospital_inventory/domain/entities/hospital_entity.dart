/// Domain entity for a hospital's overall blood bank info.
class HospitalEntity {
  const HospitalEntity({
    required this.id,
    required this.name,
    required this.department,
    required this.totalUnits,
    required this.activeRequestsCount,
    required this.criticalTypesCount,
    required this.stock,
    required this.proposals,
    required this.nearbyDonors,
  });

  final String id;
  final String name;
  final String department;
  final int totalUnits;
  final int activeRequestsCount;
  final int criticalTypesCount;
  final List<BloodStockEntity> stock;
  final List<BloodRequestEntity> proposals;
  final List<NearbyDonorEntity> nearbyDonors;
}

/// Stock level for a single blood type (e.g. "A+", "O-").
class BloodStockEntity {
  const BloodStockEntity({
    required this.bloodType,
    required this.units,
    required this.status,
  });

  final String bloodType;
  final int units;

  /// One of: normal, low, critical.
  final BloodStockStatus status;
}

enum BloodStockStatus { normal, low, critical }

/// An active blood request/proposal raised by the hospital.
class BloodRequestEntity {
  const BloodRequestEntity({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  final String id;
  final String title;
  final DateTime createdAt;
}

/// A nearby donor available to fulfil a request.
class NearbyDonorEntity {
  const NearbyDonorEntity({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.bloodType,
  });

  final String id;
  final String name;
  final double distanceKm;
  final String bloodType;
}
