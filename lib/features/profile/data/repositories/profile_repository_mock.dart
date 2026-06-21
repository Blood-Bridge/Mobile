import 'package:blood_bridge/features/profile/data/models/profile_model.dart';
import 'package:blood_bridge/features/profile/domain/entities/profile_entity.dart';
import 'package:blood_bridge/features/profile/domain/repositories/profile_repository.dart';

/// Hardcoded implementation used until the real backend endpoints
/// are wired in. Mirrors realistic latency with [Future.delayed].
class ProfileRepositoryMock implements ProfileRepository {
  ProfileModel _profile = ProfileModel(
    id: 'usr_001',
    name: 'John Doe',
    email: 'johndoe@email.com',
    phone: '+1 555 123 4567',
    location: 'San Francisco, CA',
    bloodType: 'O+',
    verifiedSince: DateTime(2024, 1, 15),
    emergencyNotificationsEnabled: true,
    locationSharingEnabled: true,
  );

  @override
  Future<ProfileEntity> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _profile;
  }

  @override
  Future<void> updatePreferences({
    required bool emergencyNotificationsEnabled,
    required bool locationSharingEnabled,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _profile = ProfileModel.fromEntity(
      _profile.copyWith(
        emergencyNotificationsEnabled: emergencyNotificationsEnabled,
        locationSharingEnabled: locationSharingEnabled,
      ),
    );
  }
}
