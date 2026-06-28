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

  // Local cache — stores requests the donor accepted this session
  final List<BloodRequestModel> _localAccepted = [];

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
      print(response.data.toString() + "gggg");
      emit(DonorsSuccess(response.data["data"]));
    } catch (e) {
      if (e is DioException) {
        emit(DonorsError(_extractError(e, "Error")));
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
        emit(DonorsError(_extractError(e, "Error")));
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
        emit(DonorsError(_extractError(e, "Error")));
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
        emit(DonorsError(_extractError(e, "Error")));
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
        emit(DonorsError(_extractError(e, "Error")));
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  int? _lastRequestId;
  int? get lastRequestId => _lastRequestId;

  Future<void> acceptRequest(
    int requestId, {
    bool fromMap = false,
    BloodRequestModel? requestModel,
  }) async {
    _lastRequestId = requestId;
    emit(DonorsLoading());
    isLoading = true;
    try {
      await DioHelper.postData(
        path: 'Donors/respond',
        body: {'requestId': requestId, 'isAccepted': true},
      );
      // Save to local cache so Deliveries tab shows it immediately
      if (requestModel != null) {
        _localAccepted.removeWhere((r) => r.requestId == requestId);
        _localAccepted.add(requestModel.copyWith(status: 'Accepted'));
      }
      emit(DonorAccepted(requestId));
    } catch (e) {
      if (e is DioException) {
        if (fromMap) {
          emit(MapError(_extractError(e, 'Accept failed')));
        } else {
          emit(DonorsError(_extractError(e, 'Accept failed')));
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
      _localAccepted.removeWhere((r) => r.requestId == requestId);
      emit(DonorsSuccess({"cancelledRequestId": requestId}));
    } catch (e) {
      if (e is DioException) {
        emit(DonorsError(_extractError(e, "Error cancelling acceptance")));
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
      _updateLocalStatus(requestId, 'OnTheWay');
      emit(DonorsSuccess({"onTheWayRequestId": requestId}));
    } catch (e) {
      if (e is DioException) {
        emit(DonorsError(_extractError(e, "Error marking as on the way")));
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
      _updateLocalStatus(requestId, 'Arrived');
      emit(DonorsSuccess({"arrivedRequestId": requestId}));
    } catch (e) {
      if (e is DioException) {
        emit(DonorsError(_extractError(e, "Error marking arrival")));
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
      _localAccepted.removeWhere((r) => r.requestId == requestId);
      emit(DonorsSuccess({"completedRequestId": requestId}));
    } catch (e) {
      if (e is DioException) {
        emit(DonorsError(_extractError(e, "Error completing donation")));
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
    isLoading = false;
  }

  /// Returns local cache of this session's accepted requests.
  List<BloodRequestModel> getLocalAccepted() =>
      List.unmodifiable(_localAccepted);

  void _updateLocalStatus(int requestId, String newStatus) {
    final idx = _localAccepted.indexWhere((r) => r.requestId == requestId);
    if (idx != -1) {
      _localAccepted[idx] = _localAccepted[idx].copyWith(status: newStatus);
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
        final msg = _extractError(e, "Error loading leaderboard");
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
        emit(DonorsError(_extractError(e, "Failed to delete donor")));
      } else {
        emit(DonorsError("Unexpected error"));
      }
    }
  }

  /// Safely extracts error message from DioException response.
  /// Handles cases where response.data is a String, Map, or null.
  String _extractError(DioException e, String fallback) {
    final data = e.response?.data;
    if (data == null) return fallback;
    if (data is Map) return data['message']?.toString() ?? fallback;
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }
}
