import 'package:blood_bridge/features/hospital_inventory/domain/entities/hospital_entity.dart';

/// Data-layer model for the hospital dashboard, including JSON mapping.
class HospitalModel extends HospitalEntity {
  const HospitalModel({
    required super.id,
    required super.name,
    required super.department,
    required super.totalUnits,
    required super.activeRequestsCount,
    required super.criticalTypesCount,
    required super.stock,
    required super.proposals,
    required super.nearbyDonors,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] as String,
      name: json['name'] as String,
      department: json['department'] as String,
      totalUnits: json['total_units'] as int,
      activeRequestsCount: json['active_requests_count'] as int,
      criticalTypesCount: json['critical_types_count'] as int,
      stock: (json['stock'] as List<dynamic>)
          .map((e) => BloodStockModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      proposals: (json['proposals'] as List<dynamic>)
          .map((e) => BloodRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nearbyDonors: (json['nearby_donors'] as List<dynamic>)
          .map((e) => NearbyDonorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BloodStockModel extends BloodStockEntity {
  const BloodStockModel({
    required super.bloodType,
    required super.units,
    required super.status,
  });

  factory BloodStockModel.fromJson(Map<String, dynamic> json) {
    return BloodStockModel(
      bloodType: json['blood_type'] as String,
      units: json['units'] as int,
      status: _statusFromString(json['status'] as String?),
    );
  }

  static BloodStockStatus _statusFromString(String? value) {
    switch (value) {
      case 'critical':
        return BloodStockStatus.critical;
      case 'low':
        return BloodStockStatus.low;
      default:
        return BloodStockStatus.normal;
    }
  }
}

class BloodRequestModel extends BloodRequestEntity {
  const BloodRequestModel({
    required super.id,
    required super.title,
    required super.createdAt,
  });

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
    return BloodRequestModel(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class NearbyDonorModel extends NearbyDonorEntity {
  const NearbyDonorModel({
    required super.id,
    required super.name,
    required super.distanceKm,
    required super.bloodType,
  });

  factory NearbyDonorModel.fromJson(Map<String, dynamic> json) {
    return NearbyDonorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      distanceKm: (json['distance_km'] as num).toDouble(),
      bloodType: json['blood_type'] as String,
    );
  }
}
