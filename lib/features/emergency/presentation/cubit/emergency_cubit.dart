import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/features/emergency/domain/entities/emergency_request_entity.dart';
import 'package:blood_bridge/features/emergency/domain/repositories/emergency_repository.dart';
import 'package:blood_bridge/features/emergency/presentation/cubit/emergency_state.dart';

const _availableBloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB'];

/// Drives the full emergency flow: select blood type → confirm →
/// send alert → watch donor search → request sent.
class EmergencyCubit extends Cubit<EmergencyState> {
  EmergencyCubit(this._repository, {String location = 'Current Location'})
      : super(EmergencySelecting(location: location));

  final EmergencyRepository _repository;
  StreamSubscription<EmergencyRequestEntity>? _searchSubscription;

  List<String> get availableBloodTypes => _availableBloodTypes;

  /// Called when the user taps a blood type chip on the selection screen.
  void selectBloodType(String bloodType) {
    final current = state;
    if (current is EmergencySelecting) {
      emit(current.copyWith(selectedBloodType: bloodType));
    }
  }

  /// Submits the alert (called from the "Confirm Emergency" screen) and
  /// transitions through Sending -> Searching -> Sent automatically.
  Future<void> sendEmergencyAlert() async {
    final current = state;
    if (current is! EmergencySelecting || current.selectedBloodType == null) {
      return;
    }

    emit(const EmergencySending());

    try {
      final request = await _repository.sendEmergencyAlert(
        bloodType: current.selectedBloodType!,
        location: current.location,
      );
      emit(EmergencySearching(request));

      _searchSubscription?.cancel();
      _searchSubscription = _repository.watchDonorSearch(request.id).listen(
        (updated) {
          if (updated.status == EmergencyRequestStatus.sent) {
            emit(EmergencySent(updated));
          } else {
            emit(EmergencySearching(updated));
          }
        },
        onError: (e) => emit(EmergencyError('Failed to find donors: $e')),
      );
    } catch (e) {
      emit(EmergencyError('Failed to send emergency alert: $e'));
    }
  }

  /// Resets back to the selection screen (e.g. "Back" button, or
  /// after the user dismisses the "Request Sent" confirmation).
  void reset({String location = 'Current Location'}) {
    _searchSubscription?.cancel();
    emit(EmergencySelecting(location: location));
  }

  @override
  Future<void> close() {
    _searchSubscription?.cancel();
    return super.close();
  }
}
