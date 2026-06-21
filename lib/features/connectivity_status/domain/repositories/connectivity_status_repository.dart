import 'package:blood_bridge/features/connectivity_status/domain/entities/connectivity_status_entity.dart';

/// Contract for checking internet connectivity and location service
/// availability, plus listening to changes in both.
abstract class ConnectivityStatusRepository {
  /// One-shot check of the current status.
  Future<ConnectivityStatusEntity> checkStatus();

  /// Emits a new [ConnectivityStatusEntity] whenever connectivity
  /// or location service availability changes.
  Stream<ConnectivityStatusEntity> watchStatus();

  /// Opens the device location settings so the user can enable it.
  Future<void> openLocationSettings();
}
