import 'package:dio/dio.dart';
import 'package:blood_bridge/features/donor_search/domain/entities/donor_search_result_entity.dart';
import 'package:blood_bridge/features/donor_search/domain/repositories/donor_search_repository.dart';

/// Real backend implementation.
///
/// TODO: replace [_baseUrl] and endpoint path once the backend
/// links are shared.
class DonorSearchRepositoryImpl implements DonorSearchRepository {
  DonorSearchRepositoryImpl({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(),
        _baseUrl = baseUrl ?? _placeholderBaseUrl;

  final Dio _dio;
  final String _baseUrl;

  static const String _placeholderBaseUrl = 'https://api.blood-bridge.example.com';

  @override
  Future<DonorSearchResultEntity> searchDonors({
    required String bloodType,
    required double radiusKm,
  }) async {
    final response = await _dio.get(
      '$_baseUrl/donors/search',
      queryParameters: {'blood_type': bloodType, 'radius_km': radiusKm},
    );
    final data = response.data as Map<String, dynamic>;
    return DonorSearchResultEntity(
      donorsFound: data['donors_found'] as int,
      searchRadiusKm: (data['search_radius_km'] as num).toDouble(),
    );
  }
}
