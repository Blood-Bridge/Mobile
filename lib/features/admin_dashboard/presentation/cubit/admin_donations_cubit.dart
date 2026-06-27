import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/features/donations/data/models/donation_model.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/cubit/admin_donations_state.dart';

class AdminDonationsCubit extends Cubit<AdminDonationsState> {
  AdminDonationsCubit() : super(AdminDonationsInitial());

  Future<void> fetchDonations({
    String? governorate,
    String? confirmationStatus,
    int page = 1,
    int pageSize = 10,
  }) async {
    emit(AdminDonationsLoading());
    try {
      final response = await DioHelper.getData(
        path: 'Admin/donations',
        queryParameters: {
          if (governorate != null && governorate.isNotEmpty) 'governorate': governorate,
          if (confirmationStatus != null && confirmationStatus.isNotEmpty) 'confirmationStatus': confirmationStatus,
          'pageNumber': page,
          'pageSize': pageSize,
        },
      );

      final rawItems = response.data['data']?['items'] as List<dynamic>? ?? [];
      final list = rawItems.map((e) => DonationModel.fromJson(e as Map<String, dynamic>)).toList();

      final pageNumber = response.data['data']?['pageNumber'] as int? ?? 1;
      final totalPages = response.data['data']?['totalPages'] as int? ?? 1;

      emit(AdminDonationsLoaded(
        donations: list,
        pageNumber: pageNumber,
        totalPages: totalPages,
      ));
    } on DioException catch (e) {
      emit(AdminDonationsError(
        e.response?.data?['message'] ?? 'Failed to load admin donations',
      ));
    } catch (_) {
      emit(const AdminDonationsError('Unexpected error occurred'));
    }
  }

  Future<void> deleteDonation(int donationProcessId) async {
    // Delete donation endpoint: DELETE /api/Donations/delete/{id}
    try {
      final response = await DioHelper.deleteData(path: 'Donations/delete/$donationProcessId');
      if (response.statusCode == 200) {
        fetchDonations();
      }
    } catch (_) {
      // Fail silently
    }
  }
}
