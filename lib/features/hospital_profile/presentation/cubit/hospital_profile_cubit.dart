import 'package:blood_bridge/core/models/hospital_profile.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'hospital_profile_state.dart';

class HospitalProfileCubit extends Cubit<HospitalProfileState> {
  HospitalProfileCubit() : super(HospitalProfileInitial());

  Future<void> fetchProfile() async {
    emit(HospitalProfileLoading());
    try {
      final response = await DioHelper.getData(path: 'Hospital/profile');
      if (response.statusCode == 200) {
        final dynamic rawData = response.data?['data'] ?? response.data;
        if (rawData is Map<String, dynamic>) {
          emit(HospitalProfileLoaded(HospitalProfile.fromJson(rawData)));
        } else {
          emit(HospitalProfileError('Invalid profile data format'));
        }
      } else {
        emit(
          HospitalProfileError(
            _extractMessage(response.data, 'Failed to load profile'),
          ),
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(HospitalProfileError('Session expired. Please login again.'));
      } else {
        emit(
          HospitalProfileError(
            _extractMessage(
              e.response?.data,
              e.message ?? 'Failed to load profile',
            ),
          ),
        );
      }
    } catch (e) {
      emit(HospitalProfileError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phoneNumber,
    required String governorate,
    required String licenseNumber,
    required String hospitalType,
    required int capacity,
    required bool hasBloodBank,
  }) async {
    emit(HospitalProfileLoading());
    try {
      final response = await DioHelper.putData(
        path: 'Hospital/update-profile',
        body: {
          'name': name,
          'phoneNumber': phoneNumber,
          'governorate': governorate,
          'licenseNumber': licenseNumber,
          'hospitalType': hospitalType,
          'capacity': capacity,
          'hasBloodBank': hasBloodBank,
        },
      );
      if (response.statusCode == 200) {
        await fetchProfile();
      } else {
        emit(
          HospitalProfileError(
            _extractMessage(response.data, 'Failed to update profile'),
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        HospitalProfileError(
          _extractMessage(e.response?.data, 'Failed to update profile'),
        ),
      );
    } catch (e) {
      emit(HospitalProfileError('Unexpected error: ${e.toString()}'));
    }
  }

  String _extractMessage(dynamic data, String fallback) {
    if (data is Map) return data['message']?.toString() ?? fallback;
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }
}
