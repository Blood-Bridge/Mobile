import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/switch_role_cubit/switch_role_state.dart';

class SwitchRoleCubit extends Cubit<SwitchRoleState> {
  SwitchRoleCubit() : super(SwitchRoleInitial());

  Future<void> switchToDonor({
    required double weight,
    required String dateOfBirth,
    required String medicalHistory,
    required String nationalId,
    required double latitude,
    required double longitude,
  }) async {
    emit(SwitchRoleLoading());
    try {
      final response = await DioHelper.patchData(
        path: 'Users/switch-to-donor',
        body: {
          'weight': weight,
          'dateOfBirth': dateOfBirth,
          'medicalHistory': medicalHistory,
          'nationalId': nationalId,
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(
          SwitchRoleSuccess(
            response.data?['message']?.toString() ??
                'Role switched to Donor successfully. Please log back in.',
          ),
        );
      } else {
        emit(SwitchRoleError('Failed to switch role'));
      }
    } on DioException catch (e) {
      String errorMsg =
          'Failed to switch role. Check your eligibility criteria.';

      // ✅ الحل الآمن للتعامل مع String أو Map
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMsg =
              e.response!.data['message']?.toString() ??
              e.response!.data['error']?.toString() ??
              errorMsg;
        } else if (e.response!.data is String) {
          errorMsg = e.response!.data.toString();
        }
      }

      emit(SwitchRoleError(errorMsg));
    } catch (e) {
      emit(const SwitchRoleError('Unexpected error occurred'));
    }
  }

  Future<void> switchToRecipient() async {
    emit(SwitchRoleLoading());
    try {
      final response = await DioHelper.patchData(
        path: 'Users/switch-to-recipient',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(
          SwitchRoleSuccess(
            response.data?['message']?.toString() ??
                'Role switched to Recipient successfully. Please log back in.',
          ),
        );
      } else {
        emit(SwitchRoleError('Failed to switch role'));
      }
    } on DioException catch (e) {
      String errorMsg =
          'Failed to switch role. Make sure you have no pending donations.';

      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMsg = e.response!.data['message']?.toString() ?? errorMsg;
        } else if (e.response!.data is String) {
          errorMsg = e.response!.data.toString();
        }
      }

      emit(SwitchRoleError(errorMsg));
    } catch (_) {
      emit(const SwitchRoleError('Unexpected error occurred'));
    }
  }
}
