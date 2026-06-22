import 'package:dio/dio.dart';
import 'package:blood_bridge/features/emergency/data/models/emergency_request_model.dart';
import 'package:blood_bridge/features/emergency/domain/entities/emergency_request_entity.dart';
import 'package:blood_bridge/features/emergency/domain/repositories/emergency_repository.dart';

/// Real backend implementation.
///
/// TODO: replace [_baseUrl] and endpoint paths once the backend
/// links are shared. Donor-search progress is assumed to come from
/// a polling endpoint here — swap for sockets/SSE if the backend
/// supports it.
class EmergencyRepositoryImpl implements EmergencyRepository {
  EmergencyRepositoryImpl({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(),
        _baseUrl = baseUrl ?? _placeholderBaseUrl;

  final Dio _dio;
  final String _baseUrl;

  static const String _placeholderBaseUrl = 'https://api.blood-bridge.example.com';

  @override
  Future<EmergencyRequestEntity> sendEmergencyAlert({
    required String bloodType,
    required String location,
  }) async {
    final response = await _dio.post(
      '$_baseUrl/emergency-requests',
      data: {'blood_type': bloodType, 'location': location},
    );
    return EmergencyRequestModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Stream<EmergencyRequestEntity> watchDonorSearch(String requestId) async* {
    // Polling fallback. Replace with a socket/SSE stream if available.
    while (true) {
      final response = await _dio.get('$_baseUrl/emergency-requests/$requestId');
      final model = EmergencyRequestModel.fromJson(response.data as Map<String, dynamic>);
      yield model;
      if (model.status == EmergencyRequestStatus.sent) break;
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
