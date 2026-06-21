import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/features/profile/domain/repositories/profile_repository.dart';
import 'package:blood_bridge/features/profile/presentation/cubit/profile_state.dart';

/// Manages loading the donor profile and toggling preferences.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileInitial());

  final ProfileRepository _repository;

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    try {
      final profile = await _repository.getProfile();
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  /// Toggles the "Emergency Notifications" preference.
  ///
  /// Updates the UI immediately (optimistic) and rolls back if the
  /// backend call fails.
  Future<void> toggleEmergencyNotifications(bool value) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    final updatedProfile = current.profile.copyWith(
      emergencyNotificationsEnabled: value,
    );
    emit(current.copyWith(profile: updatedProfile, isUpdating: true));

    try {
      await _repository.updatePreferences(
        emergencyNotificationsEnabled: value,
        locationSharingEnabled: updatedProfile.locationSharingEnabled,
      );
      emit(current.copyWith(profile: updatedProfile, isUpdating: false));
    } catch (e) {
      // Roll back on failure.
      emit(current.copyWith(profile: current.profile, isUpdating: false));
    }
  }

  /// Toggles the "Location Sharing" preference.
  Future<void> toggleLocationSharing(bool value) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    final updatedProfile = current.profile.copyWith(
      locationSharingEnabled: value,
    );
    emit(current.copyWith(profile: updatedProfile, isUpdating: true));

    try {
      await _repository.updatePreferences(
        emergencyNotificationsEnabled: updatedProfile.emergencyNotificationsEnabled,
        locationSharingEnabled: value,
      );
      emit(current.copyWith(profile: updatedProfile, isUpdating: false));
    } catch (e) {
      emit(current.copyWith(profile: current.profile, isUpdating: false));
    }
  }
}
