import 'package:bloc/bloc.dart';
import 'package:blood_bridge/core/models/user_profile.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:dio/dio.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    try {
      final response = await DioHelper.getData(path: 'Users/profile');

      print("📡 Profile Response: ${response.statusCode}");
      print("📦 Profile Data Type: ${response.data.runtimeType}");

      if (response.statusCode == 200) {
        print(response.data);
        final dynamic rawData = response.data?['data'] ?? response.data;

        if (rawData is Map<String, dynamic>) {
          final profile = UserProfile.fromJson(rawData);
          emit(ProfileLoaded(profile));
        } else {
          emit(const ProfileError("Invalid profile data format"));
        }
      } else {
        emit(
          ProfileError(
            response.data?['message']?.toString() ?? 'Failed to load profile',
          ),
        );
      }
    } on DioException catch (e) {
      print(e.response?.data["message"].toString());

      // Handle 401 properly
      if (e.response?.statusCode == 401) {
        emit(const ProfileError("Session expired. Please login again."));
        // Optional: Trigger logout
        // await _handleLogout();
      } else {
        emit(
          ProfileError(
            e.response?.data?['message']?.toString() ??
                e.message ??
                'Failed to load profile',
          ),
        );
      }
    } catch (e) {
      print("❌ Profile Unexpected Error: $e");
      emit(ProfileError('Unexpected error: ${e.toString()}'));
    }
  }
}
