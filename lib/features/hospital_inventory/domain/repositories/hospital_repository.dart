import 'package:blood_bridge/features/hospital_inventory/domain/entities/hospital_entity.dart';

/// Contract for fetching hospital blood-bank dashboard data and
/// submitting a new blood request.
///
/// Implemented by [HospitalRepositoryMock] (hardcoded, used now)
/// and [HospitalRepositoryImpl] (real API, plug in endpoints later).
abstract class HospitalRepository {
  /// Fetches the dashboard for a given hospital (stock, proposals, donors).
  Future<HospitalEntity> getHospitalDashboard(String hospitalId);

  /// Submits a new blood request for the given hospital.
  Future<void> submitBloodRequest({
    required String hospitalId,
    required String bloodType,
    required int unitsNeeded,
  });
}
