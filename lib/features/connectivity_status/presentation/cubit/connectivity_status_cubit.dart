import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/features/connectivity_status/domain/entities/connectivity_status_entity.dart';
import 'package:blood_bridge/features/connectivity_status/domain/repositories/connectivity_status_repository.dart';

class ConnectivityStatusState extends Equatable {
  const ConnectivityStatusState({required this.status});

  final AppStatus status;

  bool get isOk => status == AppStatus.ok;

  @override
  List<Object?> get props => [status];
}

/// App-wide cubit that watches internet connectivity and location
/// service availability, exposing a single [AppStatus] for the
/// [ConnectivityStatusOverlay] to react to.
class ConnectivityStatusCubit extends Cubit<ConnectivityStatusState> {
  ConnectivityStatusCubit(this._repository)
      : super(const ConnectivityStatusState(status: AppStatus.ok));

  final ConnectivityStatusRepository _repository;
  StreamSubscription<ConnectivityStatusEntity>? _subscription;

  /// Starts listening for connectivity/location changes. Call once,
  /// typically from the root widget's `initState`.
  Future<void> start() async {
    final initial = await _repository.checkStatus();
    emit(ConnectivityStatusState(status: initial.status));

    _subscription = _repository.watchStatus().listen((entity) {
      emit(ConnectivityStatusState(status: entity.status));
    });
  }

  /// Re-runs the check manually (e.g. when the user taps "Retry").
  Future<void> recheck() async {
    final result = await _repository.checkStatus();
    emit(ConnectivityStatusState(status: result.status));
  }

  Future<void> openLocationSettings() => _repository.openLocationSettings();

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
