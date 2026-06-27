import 'package:blood_bridge/core/models/blood_request_model.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
part 'donor_state.dart';

class DonorCubit extends Cubit<DonorState> {
  DonorCubit() : super(DonorInitial());
  bool isLoading = false;
  bool isAvilable = true;

  Future<void> changeAvilablity({required bool isAvailable}) async {
    emit(DonorsLoading());
    isLoading = true;
    this.isAvilable = isAvailable;
    try {
      final response = await DioHelper.putData(
        path: "Users/availability",
        queryParameters: {"isAvailable": isAvailable},
      );
      await HiveHelper.setAvailability(isAvailable);
      emit(DonorsSuccess(response.data["data"]));
    } catch (e) {
      if (e is DioException) {
        emit(DonorsError(e.response?.data["message"].toString() ?? "Error"));
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  Future<void> getAllDonors({
    String? governorate,
    String? bloodType,
    int page = 1,
  }) async {
    emit(DonorsLoading());
    isLoading = true;
    try {
      final response = await DioHelper.getData(
        path: "Admin/donors",
        queryParameters: {
          if (governorate != null) 'governorate': governorate,
          if (bloodType != null) 'bloodType': bloodType,
          'pageNumber': page,
          'pageSize': 20,
        },
      );
      emit(DonorsSuccess(response.data["data"]));
    } catch (e) {
      if (e is DioException) {
        emit(DonorsError(e.response?.data["message"].toString() ?? "Error"));
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  Future<void> getDonorById(int id) async {
    emit(DonorsLoading());
    isLoading = true;
    try {
      final response = await DioHelper.getData(
        path: "Admin/donors",
        queryParameters: {'pageSize': 100},
      );
      final list = response.data["data"]?["items"] as List<dynamic>? ?? [];
      final donor = list.where((d) => d['id'] == id).toList();
      emit(DonorsSuccess(donor));
    } catch (e) {
      if (e is DioException) {
        emit(DonorsError(e.response?.data["message"].toString() ?? "Error"));
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  Future<void> matchDonors(int requestId) async {
    emit(DonorsLoading());
    isLoading = true;
    try {
      final response = await DioHelper.getData(path: "Donors/match/$requestId");
      emit(DonorsSuccess(response.data["data"]));
    } catch (e) {
      if (e is DioException) {
        emit(DonorsError(e.response?.data["message"].toString() ?? "Error"));
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  Future<void> respond({
    required int requestId,
    required bool isAccepted,
  }) async {
    emit(DonorsLoading());
    isLoading = true;
    try {
      await DioHelper.postData(
        path: "Donors/respond",
        body: {"requestId": requestId, "isAccepted": isAccepted},
      );
      emit(DonorsSuccess([]));
    } catch (e) {
      if (e is DioException) {
        emit(DonorsError(e.response?.data["message"].toString() ?? "Error"));
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  int? _lastRequestId;
  int? get lastRequestId => _lastRequestId;

  // =========================
  // ✅ Accept Request — emits DonorAccepted so UI can switch to Deliveries tab
  // =========================
  Future<void> acceptRequest(int requestId, {bool fromMap = false}) async {
    _lastRequestId = requestId;
    emit(DonorsLoading());
    isLoading = true;
    try {
      await DioHelper.postData(
        path: 'Donors/respond',
        body: {'requestId': requestId, 'isAccepted': true},
      );
      emit(DonorAccepted(requestId));
    } catch (e) {
      if (e is DioException) {
        if (fromMap) {
          emit(
            MapError(e.response?.data["message"].toString() ?? 'Accept failed'),
          );
        } else {
          emit(
            DonorsError(
              e.response?.data["message"].toString() ?? 'Accept failed',
            ),
          );
        }
      } else {
        emit(DonorsError('Unexpected error'));
      }
    }
    isLoading = false;
  }

  Future<void> rejectRequest(int requestId) async {
    _lastRequestId = requestId;
    await respond(requestId: requestId, isAccepted: false);
  }

  Future<void> cancelAcceptance(int requestId) async {
    _lastRequestId = requestId;
    emit(DonorsLoading());
    isLoading = true;
    try {
      await DioHelper.postData(
        path: "Donors/respond",
        body: {"requestId": requestId, "isAccepted": false},
      );
      emit(DonorsSuccess({"cancelledRequestId": requestId}));
    } catch (e) {
      if (e is DioException) {
        emit(
          DonorsError(
            e.response?.data["message"]?.toString() ??
                "Error cancelling acceptance",
          ),
        );
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  Future<void> markOnTheWay(int requestId) async {
    _lastRequestId = requestId;
    emit(DonorsLoading());
    isLoading = true;
    try {
      await DioHelper.postData(
        path: "Donors/on-the-way",
        body: {"requestId": requestId},
      );
      emit(DonorsSuccess({"onTheWayRequestId": requestId}));
    } catch (e) {
      if (e is DioException) {
        emit(
          DonorsError(
            e.response?.data["message"]?.toString() ??
                "Error marking as on the way",
          ),
        );
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  Future<void> markArrived(int requestId) async {
    _lastRequestId = requestId;
    emit(DonorsLoading());
    isLoading = true;
    try {
      await DioHelper.postData(
        path: "Donors/arrived",
        body: {"requestId": requestId},
      );
      emit(DonorsSuccess({"arrivedRequestId": requestId}));
    } catch (e) {
      if (e is DioException) {
        emit(
          DonorsError(
            e.response?.data["message"]?.toString() ?? "Error marking arrival",
          ),
        );
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  Future<void> completeDonation(int requestId) async {
    _lastRequestId = requestId;
    emit(DonorsLoading());
    isLoading = true;
    try {
      await DioHelper.postData(
        path: "Donors/complete",
        body: {"requestId": requestId},
      );
      emit(DonorsSuccess({"completedRequestId": requestId}));
    } catch (e) {
      if (e is DioException) {
        emit(
          DonorsError(
            e.response?.data["message"]?.toString() ??
                "Error completing donation",
          ),
        );
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  // =========================
  // 🆕 getAcceptedRequests — fetches donor's accepted/in-progress requests
  //    Primary: GET Donors/accepted-requests
  //    Fallback: GET Requests/history filtered by active delivery statuses
  // =========================
  Future<void> getAcceptedRequests() async {
    emit(DonorAcceptedRequestsLoading());
    isLoading = true;
    try {
      final response = await DioHelper.getData(
        path: 'Donors/accepted-requests',
      );
      final dynamic dataField = response.data?['data'];
      List<dynamic> rawItems = [];
      if (dataField is List) {
        rawItems = dataField;
      } else if (dataField is Map) {
        rawItems = dataField['items'] as List<dynamic>? ?? [];
      }
      final items = rawItems
          .map((e) => BloodRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(DonorAcceptedRequestsLoaded(items));
    } on DioException catch (e) {
      // ── Fallback: endpoint not yet on backend ──
      debugPrint(
        '⚠️  Donors/accepted-requests not found (${e.response?.statusCode}), using history fallback',
      );
      await _loadAcceptedFromHistory();
    } catch (e) {
      emit(DonorAcceptedRequestsError('Unexpected error: ${e.toString()}'));
    }
    isLoading = false;
  }

  Future<void> _loadAcceptedFromHistory() async {
    try {
      final response = await DioHelper.getData(path: 'Requests/history');
      final dynamic dataField = response.data?['data'];
      List<dynamic> rawItems = [];
      if (dataField is List) {
        rawItems = dataField;
      } else if (dataField is Map) {
        rawItems = dataField['items'] as List<dynamic>? ?? [];
      }
      final items = rawItems
          .map((e) => BloodRequestModel.fromJson(e as Map<String, dynamic>))
          .where((req) {
            final s = req.status
                .toLowerCase()
                .replaceAll('_', '')
                .replaceAll(' ', '');
            return s == 'accepted' || s == 'ontheway' || s == 'arrived';
          })
          .toList();
      emit(DonorAcceptedRequestsLoaded(items));
    } on DioException catch (e) {
      emit(
        DonorAcceptedRequestsError(
          e.response?.data?['message']?.toString() ??
              'Failed to load accepted requests',
        ),
      );
    } catch (e) {
      emit(DonorAcceptedRequestsError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> getLeaderboard() async {
    emit(DonorsLoading());
    isLoading = true;
    try {
      final response = await DioHelper.getData(path: "Donors/leaderboard");
      final data =
          response.data?['data']?['items'] ?? response.data?['items'] ?? [];
      emit(DonorsSuccess(data));
    } catch (e) {
      if (e is DioException) {
        final msg =
            e.response?.data?['message']?.toString() ??
            "Error loading leaderboard";
        emit(DonorsError(msg));
      } else {
        emit(DonorsError("Unexpected error"));
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteDonor(int id) async {
    emit(DonorsLoading());
    try {
      final response = await DioHelper.deleteData(path: "Admin/donors/$id");
      if (response.statusCode == 200) {
        emit(DonorDeleteSuccess());
      } else {
        emit(DonorsError(response.data["message"] ?? "Failed to delete donor"));
      }
    } catch (e) {
      if (e is DioException) {
        emit(
          DonorsError(e.response?.data?["message"] ?? "Failed to delete donor"),
        );
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
  }
}
