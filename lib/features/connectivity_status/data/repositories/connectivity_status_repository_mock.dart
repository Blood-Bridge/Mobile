import 'dart:async';

import 'package:blood_bridge/features/connectivity_status/domain/entities/connectivity_status_entity.dart';
import 'package:blood_bridge/features/connectivity_status/domain/repositories/connectivity_status_repository.dart';

/// In-memory mock used for development/testing the overlay UI
/// without depending on `connectivity_plus`/`geolocator`.
///
/// Call [emitStatus] from a debug menu to simulate status changes.
class ConnectivityStatusRepositoryMock implements ConnectivityStatusRepository {
  final _controller = _StatusController(
    const ConnectivityStatusEntity(
      status: AppStatus.ok,
      hasInternet: true,
      isLocationEnabled: true,
    ),
  );

  @override
  Future<ConnectivityStatusEntity> checkStatus() async => _controller.current;

  @override
  Stream<ConnectivityStatusEntity> watchStatus() => _controller.stream;

  @override
  Future<void> openLocationSettings() async {
    // Simulate the user enabling location after visiting settings.
    emitStatus(
      const ConnectivityStatusEntity(
        status: AppStatus.ok,
        hasInternet: true,
        isLocationEnabled: true,
      ),
    );
  }

  /// Manually push a new status (for debug/testing).
  void emitStatus(ConnectivityStatusEntity status) => _controller.emit(status);
}

class _StatusController {
  _StatusController(this.current);

  ConnectivityStatusEntity current;
  final _stream = _BroadcastStream<ConnectivityStatusEntity>();

  Stream<ConnectivityStatusEntity> get stream => _stream.stream;

  void emit(ConnectivityStatusEntity value) {
    current = value;
    _stream.add(value);
  }
}

/// Tiny broadcast-stream wrapper to avoid pulling in extra deps for the mock.
class _BroadcastStream<T> {
  final _controller = StreamController<T>.broadcast();

  Stream<T> get stream => _controller.stream;

  void add(T value) => _controller.add(value);
}
