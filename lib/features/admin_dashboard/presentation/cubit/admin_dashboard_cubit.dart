import 'package:bloc/bloc.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_state.dart';
part 'admin_dashboard_cubit.freezed.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  AdminDashboardCubit() : super(AdminDashboardState.initial());

  Future<void> fetchDashboardData() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await DioHelper.getData(path: "Admin/stats");

      if (response.statusCode == 200) {
        final data = response.data["data"];

        // The stats endpoint may return a structured map or a string summary.
        // Parse defensively — fall back to zero for any missing field.
        if (data is Map<String, dynamic>) {
          emit(
            state.copyWith(
              isLoading: false,
              userCount: _toInt(data["userCount"] ?? data["totalUsers"]),
              donorCount: _toInt(data["donorCount"] ?? data["totalDonors"]),
              recipientCount:
                  _toInt(data["recipientCount"] ?? data["totalRecipients"]),
              hospitalCount:
                  _toInt(data["hospitalCount"] ?? data["totalHospitals"]),
              totalRequests:
                  _toInt(data["totalRequests"] ?? data["requestCount"]),
              pendingRequests: _toInt(data["pendingRequests"]),
              completedRequests: _toInt(data["completedRequests"]),
            ),
          );
        } else {
          // API returned a plain string or unexpected shape — keep zeros, clear loading
          emit(state.copyWith(isLoading: false));
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: response.data["message"] ?? "Failed to load stats",
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.response?.data?["message"] ?? "Network error",
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
