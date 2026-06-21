import 'package:dio/dio.dart';
import 'package:blood_bridge/features/profile/data/models/profile_model.dart';
import 'package:blood_bridge/features/profile/domain/entities/profile_entity.dart';
import 'package:blood_bridge/features/profile/domain/repositories/profile_repository.dart';

/// Real backend implementation.
///
/// TODO: replace [_baseUrl] and endpoint paths once the backend
/// links are shared. The shape of requests/responses below is a
/// best guess based on [ProfileModel.fromJson] / `toJson`.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(),
        _baseUrl = baseUrl ?? _placeholderBaseUrl;

  final Dio _dio;
  final String _baseUrl;

  static const String _placeholderBaseUrl = 'https://api.blood-bridge.example.com';

  @override
  Future<ProfileEntity> getProfile() async {
    final response = await _dio.get('$_baseUrl/profile');
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> updatePreferences({
    required bool emergencyNotificationsEnabled,
    required bool locationSharingEnabled,
  }) async {
    await _dio.patch(
      '$_baseUrl/profile/preferences',
      data: {
        'emergency_notifications_enabled': emergencyNotificationsEnabled,
        'location_sharing_enabled': locationSharingEnabled,
      },
    );
  }
}
