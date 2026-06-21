import 'package:blood_bridge/features/profile/domain/entities/profile_entity.dart';

/// Contract for fetching and updating the donor profile.
///
/// Implemented by [ProfileRepositoryMock] (hardcoded data, used now)
/// and [ProfileRepositoryImpl] (real API, plug in endpoints later).
abstract class ProfileRepository {
  /// Fetches the current user's profile.
  Future<ProfileEntity> getProfile();

  /// Persists preference toggles (emergency notifications / location sharing).
  Future<void> updatePreferences({
    required bool emergencyNotificationsEnabled,
    required bool locationSharingEnabled,
  });
}
