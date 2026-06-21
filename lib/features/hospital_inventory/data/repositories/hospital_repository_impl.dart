import 'package:dio/dio.dart';
import 'package:blood_bridge/features/hospital_inventory/data/models/hospital_model.dart';
import 'package:blood_bridge/features/hospital_inventory/domain/entities/hospital_entity.dart';
import 'package:blood_bridge/features/hospital_inventory/domain/repositories/hospital_repository.dart';

/// Real backend implementation.
///
/// TODO: replace [_baseUrl] and endpoint paths once the backend
/// links are shared. The shape of requests/responses below is a
/// best guess based on [HospitalModel.fromJson].
class HospitalRepositoryImpl implements HospitalRepository {
  HospitalRepositoryImpl({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(),
        _baseUrl = baseUrl ?? _placeholderBaseUrl;

  final Dio _dio;
  final String _baseUrl;

  static const String _placeholderBaseUrl = 'https://api.blood-bridge.example.com';

  @override
  Future<HospitalEntity> getHospitalDashboard(String hospitalId) async {
    final response = await _dio.get('$_baseUrl/hospitals/$hospitalId/dashboard');
    return HospitalModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> submitBloodRequest({
    required String hospitalId,
    required String bloodType,
    required int unitsNeeded,
  }) async {
    await _dio.post(
      '$_baseUrl/hospitals/$hospitalId/requests',
      data: {
        'blood_type': bloodType,
        'units_needed': unitsNeeded,
      },
    );
  }
}
