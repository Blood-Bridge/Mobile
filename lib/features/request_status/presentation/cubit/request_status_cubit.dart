import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/features/request_status/data/models/request_status_model.dart';
import 'package:blood_bridge/features/request_status/presentation/cubit/request_status_state.dart';
import 'package:flutter/foundation.dart';

class RequestStatusCubit extends Cubit<RequestStatusState> {
  RequestStatusCubit() : super(RequestStatusInitial());

  Future<void> getRequestStatus(int id) async {
    emit(RequestStatusLoading());
    try {
      final response = await DioHelper.getData(path: 'Requests/$id/status');

      debugPrint('*** Response Status: ${response.statusCode}');
      debugPrint('*** Response Data: ${response.data}');

      final dynamic responseData = response.data;

      if (responseData == null) {
        emit(const RequestStatusError("No data received from server"));
        return;
      }

      // ✅ التصحيح المهم
      final requestStatus = RequestStatusModel.fromJson(responseData);

      emit(RequestStatusLoaded(requestStatus));
    } on DioException catch (e) {
      emit(
        RequestStatusError(
          e.response?.data?['message']?.toString() ??
              e.response?.data?.toString() ??
              'Failed to get request status',
        ),
      );
    } catch (e) {
      emit(RequestStatusError('Unexpected error: ${e.toString()}'));
    }
  }
}
