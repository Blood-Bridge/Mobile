import 'dart:async';
import 'dart:math';

import 'package:blood_bridge/features/emergency/domain/entities/emergency_request_entity.dart';
import 'package:blood_bridge/features/emergency/domain/repositories/emergency_repository.dart';

/// Hardcoded implementation used until the real backend endpoints
/// are wired in. Simulates the "finding donors" progress with a
/// timed stream so the UI can show live updates.
class EmergencyRepositoryMock implements EmergencyRepository {
  final _random = Random();

  @override
  Future<EmergencyRequestEntity> sendEmergencyAlert({
    required String bloodType,
    required String location,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return EmergencyRequestEntity(
      id: 'emg_${DateTime.now().millisecondsSinceEpoch}',
      bloodType: bloodType,
      location: location,
      alertRadiusKm: 5,
      donorsAlerted: 0,
      donorsConfirmed: 0,
      status: EmergencyRequestStatus.searching,
    );
  }

  @override
  Stream<EmergencyRequestEntity> watchDonorSearch(String requestId) async* {
    // Simulate donors being alerted/confirmed over a few seconds,
    // then mark the request as sent.
    var alerted = 0;
    var confirmed = 0;
    const totalSteps = 5;

    for (var step = 0; step < totalSteps; step++) {
      await Future.delayed(const Duration(milliseconds: 700));
      alerted += 3 + _random.nextInt(4);
      if (step >= 2) confirmed += _random.nextInt(3);

      yield EmergencyRequestEntity(
        id: requestId,
        bloodType: 'A+',
        location: 'Current Location',
        alertRadiusKm: 5,
        donorsAlerted: alerted,
        donorsConfirmed: confirmed,
        status: EmergencyRequestStatus.searching,
      );
    }

    yield EmergencyRequestEntity(
      id: requestId,
      bloodType: 'A+',
      location: 'Current Location',
      alertRadiusKm: 5,
      donorsAlerted: alerted,
      donorsConfirmed: confirmed,
      status: EmergencyRequestStatus.sent,
    );
  }
}
