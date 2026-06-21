import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blood_bridge/features/connectivity_status/domain/entities/connectivity_status_entity.dart';
import 'package:blood_bridge/features/connectivity_status/domain/repositories/connectivity_status_repository.dart';

/// Real implementation backed by `connectivity_plus` (internet) and
/// `geolocator` (location service availability).
///
/// Add to pubspec.yaml:
/// ```yaml
/// connectivity_plus: ^6.0.0
/// geolocator: ^13.0.0
/// ```
class ConnectivityStatusRepositoryImpl implements ConnectivityStatusRepository {
  ConnectivityStatusRepositoryImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<ConnectivityStatusEntity> checkStatus() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final hasInternet = !connectivityResult.contains(ConnectivityResult.none);

    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    return _buildEntity(hasInternet: hasInternet, isLocationEnabled: isLocationEnabled);
  }

  @override
  Stream<ConnectivityStatusEntity> watchStatus() async* {
    // Merge connectivity changes and location service changes into one
    // stream of computed statuses.
    final connectivityStream = _connectivity.onConnectivityChanged;
    final locationStream = Geolocator.getServiceStatusStream();

    bool hasInternet = true;
    bool isLocationEnabled = true;

    // Seed with current values.
    final initial = await checkStatus();
    hasInternet = initial.hasInternet;
    isLocationEnabled = initial.isLocationEnabled;
    yield initial;

    await for (final event in _mergeStreams(connectivityStream, locationStream)) {
      if (event is List<ConnectivityResult>) {
        hasInternet = !event.contains(ConnectivityResult.none);
      } else if (event is ServiceStatus) {
        isLocationEnabled = event == ServiceStatus.enabled;
      }
      yield _buildEntity(hasInternet: hasInternet, isLocationEnabled: isLocationEnabled);
    }
  }

  @override
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  ConnectivityStatusEntity _buildEntity({
    required bool hasInternet,
    required bool isLocationEnabled,
  }) {
    AppStatus status;
    if (!hasInternet) {
      status = AppStatus.noConnection;
    } else if (!isLocationEnabled) {
      status = AppStatus.locationDisabled;
    } else {
      status = AppStatus.ok;
    }

    return ConnectivityStatusEntity(
      status: status,
      hasInternet: hasInternet,
      isLocationEnabled: isLocationEnabled,
    );
  }

  /// Combines two streams into one, emitting whichever event arrives.
  Stream<dynamic> _mergeStreams(
    Stream<List<ConnectivityResult>> a,
    Stream<ServiceStatus> b,
  ) {
    final controller = StreamController<dynamic>();
    final subA = a.listen(controller.add, onError: controller.addError);
    final subB = b.listen(controller.add, onError: controller.addError);

    controller.onCancel = () {
      subA.cancel();
      subB.cancel();
    };

    return controller.stream;
  }
}
