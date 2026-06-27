import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/core/models/blood_request_model.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/cubit/admin_requests_state.dart';

class AdminRequestsCubit extends Cubit<AdminRequestsState> {
  AdminRequestsCubit() : super(AdminRequestsInitial());

  Future<void> fetchRequests({
    String? governorate,
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    emit(AdminRequestsLoading());
    try {
      final response = await DioHelper.getData(
        path: 'Admin/requests',
        queryParameters: {
          if (governorate != null && governorate.isNotEmpty) 'governorate': governorate,
          if (status != null && status.isNotEmpty) 'status': status,
          'pageNumber': page,
          'pageSize': pageSize,
        },
      );

      final rawItems = response.data['data']?['items'] as List<dynamic>? ?? [];
      final list = rawItems.map((e) => BloodRequestModel.fromJson(e as Map<String, dynamic>)).toList();
      
      final pageNumber = response.data['data']?['pageNumber'] as int? ?? 1;
      final totalPages = response.data['data']?['totalPages'] as int? ?? 1;

      emit(AdminRequestsLoaded(
        requests: list,
        pageNumber: pageNumber,
        totalPages: totalPages,
      ));
    } on DioException catch (e) {
      emit(AdminRequestsError(
        e.response?.data?['message'] ?? 'Failed to load admin requests',
      ));
    } catch (_) {
      emit(const AdminRequestsError('Unexpected error occurred'));
    }
  }

  Future<void> deleteRequest(int requestId) async {
    // There is a DELETE /api/Requests/{id}/cancel in Swagger.
    // Let's call cancel since it's the cancellation/deletion endpoint for requests.
    try {
      final response = await DioHelper.deleteData(path: 'Requests/$requestId/cancel');
      if (response.statusCode == 200) {
        // Reload requests
        fetchRequests();
      }
    } catch (_) {
      // Fail silently or emit error (will be handled by reload if needed)
    }
  }
}
