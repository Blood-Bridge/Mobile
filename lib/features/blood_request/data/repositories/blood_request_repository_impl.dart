import 'package:dio/dio.dart';
import 'package:blood_bridge/features/blood_request/data/models/blood_request_model.dart';
import 'package:blood_bridge/features/blood_request/domain/entities/blood_request_entity.dart';
import 'package:blood_bridge/features/blood_request/domain/repositories/blood_request_repository.dart';

/// Real backend implementation.
///
/// TODO: replace [_baseUrl] and endpoint paths once the backend
/// links are shared.
class BloodRequestRepositoryImpl implements BloodRequestRepository {
  BloodRequestRepositoryImpl({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(),
        _baseUrl = baseUrl ?? _placeholderBaseUrl;

  final Dio _dio;
  final String _baseUrl;

  static const String _placeholderBaseUrl = 'https://api.blood-bridge.example.com';

  @override
  Future<BloodRequestEntity> getRequestDetail(String requestId) async {
    final response = await _dio.get('$_baseUrl/requests/$requestId');
    return BloodRequestModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> respondToRequest({required String requestId, required bool accept}) async {
    await _dio.post(
      '$_baseUrl/requests/$requestId/respond',
      data: {'accept': accept},
    );
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final response = await _dio.get('$_baseUrl/notifications');
    return (response.data as List<dynamic>)
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await _dio.post('$_baseUrl/notifications/mark-all-read');
  }
}
