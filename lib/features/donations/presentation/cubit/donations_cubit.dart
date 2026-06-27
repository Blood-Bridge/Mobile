import 'package:bloc/bloc.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/features/donations/data/models/donation_model.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_state.dart';
import 'package:dio/dio.dart';

class DonationsCubit extends Cubit<DonationsState> {
  DonationsCubit() : super(DonationsInitial());

  Future<void> fetchAllDonations() async {
    emit(DonationsLoading());
    try {
      final response = await DioHelper.getData(path: 'Donations/get-all');
      if (response.statusCode == 200) {
        final List<dynamic> raw = response.data['data']?['items'] as List<dynamic>? ?? [];
        final items = raw.map((e) => DonationModel.fromJson(e as Map<String, dynamic>)).toList();
        emit(DonationsLoaded(items));
      } else {
        emit(DonationsError(response.data['message'] ?? 'Failed to load donations'));
      }
    } on DioException catch (e) {
      emit(DonationsError(e.response?.data?['message'] ?? 'Failed to load donations'));
    } catch (_) {
      emit(const DonationsError('Unexpected error'));
    }
  }

  Future<void> fetchDonationById(int id) async {
    emit(DonationsLoading());
    try {
      final response = await DioHelper.getData(path: 'Donations/get-by-id/$id');
      if (response.statusCode == 200) {
        final donation = DonationModel.fromJson(response.data['data'] as Map<String, dynamic>);
        emit(DonationDetailsLoaded(donation));
      } else {
        emit(DonationsError(response.data['message'] ?? 'Failed to load details'));
      }
    } on DioException catch (e) {
      emit(DonationsError(e.response?.data?['message'] ?? 'Failed to load details'));
    } catch (_) {
      emit(const DonationsError('Unexpected error'));
    }
  }

  Future<void> createDonation({
    required int bloodRequestId,
    required int hospitalId,
    required DateTime donationDate,
  }) async {
    emit(DonationsLoading());
    try {
      final response = await DioHelper.postData(
        path: 'Donations/create',
        body: {
          'bloodRequestId': bloodRequestId,
          'hospitalId': hospitalId,
          'donationDate': donationDate.toIso8601String(),
          'confirmationStatus': 'Pending',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(DonationCreateSuccess());
      } else {
        emit(DonationsError(response.data['message'] ?? 'Failed to create donation'));
      }
    } on DioException catch (e) {
      emit(DonationsError(e.response?.data?['message'] ?? 'Failed to create donation'));
    } catch (_) {
      emit(const DonationsError('Unexpected error'));
    }
  }

  Future<void> updateDonation({
    required int id,
    required DateTime donationDate,
    required String confirmationStatus,
  }) async {
    emit(DonationsLoading());
    try {
      final response = await DioHelper.putData(
        path: 'Donations/update/$id',
        body: {
          'donationDate': donationDate.toIso8601String(),
          'confirmationStatus': confirmationStatus,
        },
      );
      if (response.statusCode == 200) {
        emit(DonationUpdateSuccess());
      } else {
        emit(DonationsError(response.data['message'] ?? 'Failed to update donation'));
      }
    } on DioException catch (e) {
      emit(DonationsError(e.response?.data?['message'] ?? 'Failed to update donation'));
    } catch (_) {
      emit(const DonationsError('Unexpected error'));
    }
  }

  Future<void> deleteDonation(int id) async {
    emit(DonationsLoading());
    try {
      final response = await DioHelper.deleteData(path: 'Donations/delete/$id');
      if (response.statusCode == 200) {
        emit(DonationDeleteSuccess());
      } else {
        emit(DonationsError(response.data['message'] ?? 'Failed to delete donation'));
      }
    } on DioException catch (e) {
      emit(DonationsError(e.response?.data?['message'] ?? 'Failed to delete donation'));
    } catch (_) {
      emit(const DonationsError('Unexpected error'));
    }
  }

  Future<void> confirmDonation(int id) async {
    emit(DonationsLoading());
    try {
      final response = await DioHelper.postData(path: 'Donations/$id/confirm');
      if (response.statusCode == 200) {
        emit(DonationConfirmSuccess());
      } else {
        emit(DonationsError(response.data['message'] ?? 'Failed to confirm donation'));
      }
    } on DioException catch (e) {
      emit(DonationsError(e.response?.data?['message'] ?? 'Failed to confirm donation'));
    } catch (_) {
      emit(const DonationsError('Unexpected error'));
    }
  }
}
