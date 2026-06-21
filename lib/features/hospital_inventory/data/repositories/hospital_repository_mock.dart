import 'package:blood_bridge/features/hospital_inventory/domain/entities/hospital_entity.dart';
import 'package:blood_bridge/features/hospital_inventory/domain/repositories/hospital_repository.dart';

/// Hardcoded implementation used until the real backend endpoints
/// are wired in. Mirrors realistic latency with [Future.delayed].
class HospitalRepositoryMock implements HospitalRepository {
  @override
  Future<HospitalEntity> getHospitalDashboard(String hospitalId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();

    return HospitalEntity(
      id: hospitalId,
      name: 'City Hospital',
      department: 'Blood Bank Department',
      totalUnits: 257,
      activeRequestsCount: 2,
      criticalTypesCount: 2,
      stock: const [
        BloodStockEntity(bloodType: 'A+', units: 45, status: BloodStockStatus.normal),
        BloodStockEntity(bloodType: 'A-', units: 12, status: BloodStockStatus.low),
        BloodStockEntity(bloodType: 'B+', units: 38, status: BloodStockStatus.normal),
        BloodStockEntity(bloodType: 'B-', units: 8, status: BloodStockStatus.critical),
        BloodStockEntity(bloodType: 'O+', units: 62, status: BloodStockStatus.normal),
        BloodStockEntity(bloodType: 'O-', units: 15, status: BloodStockStatus.low),
        BloodStockEntity(bloodType: 'AB+', units: 22, status: BloodStockStatus.normal),
        BloodStockEntity(bloodType: 'AB-', units: 6, status: BloodStockStatus.critical),
      ],
      proposals: [
        BloodRequestEntity(
          id: 'req_001',
          title: 'Emergency O- needed',
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
        BloodRequestEntity(
          id: 'req_002',
          title: 'Scheduled donation drive',
          createdAt: now.subtract(const Duration(hours: 5)),
        ),
      ],
      nearbyDonors: const [
        NearbyDonorEntity(id: 'don_001', name: 'Available Donor', distanceKm: 0.8, bloodType: 'O+'),
        NearbyDonorEntity(id: 'don_002', name: 'Available Donor', distanceKm: 1.2, bloodType: 'A-'),
        NearbyDonorEntity(id: 'don_003', name: 'Available Donor', distanceKm: 2.0, bloodType: 'B+'),
      ],
    );
  }

  @override
  Future<void> submitBloodRequest({
    required String hospitalId,
    required String bloodType,
    required int unitsNeeded,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // No-op for mock: in a real backend this would create a request record.
  }
}
