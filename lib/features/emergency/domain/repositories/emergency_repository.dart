import 'package:blood_bridge/features/emergency/domain/entities/emergency_request_entity.dart';

/// Contract for submitting an emergency blood request and tracking
/// the donor-search progress.
///
/// Implemented by [EmergencyRepositoryMock] (hardcoded, used now)
/// and [EmergencyRepositoryImpl] (real API, plug in endpoints later).
abstract class EmergencyRepository {
  /// Sends the emergency alert for the given blood type and current
  /// location. Returns the created request with an id.
  Future<EmergencyRequestEntity> sendEmergencyAlert({
    required String bloodType,
    required String location,
  });

  /// Streams donor-search progress (number of donors alerted/confirmed)
  /// until the search completes and the request status becomes "sent".
  Stream<EmergencyRequestEntity> watchDonorSearch(String requestId);
}
