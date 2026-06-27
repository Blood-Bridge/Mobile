import 'package:bloc/bloc.dart';
import 'package:blood_bridge/core/models/blood_request_model.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:dio/dio.dart';

part 'receiver_state.dart';

class ReceiverCubit extends Cubit<ReceiverState> {
  ReceiverCubit() : super(ReceiverInitial());

  List<BloodRequestModel> _requests = [];
  final Map<int, dynamic> acceptedDonors = {};
  final Map<int, String> requestStatuses = {};
  final Map<int, int> matchesCounts = {};

  List<BloodRequestModel> get requests => List.unmodifiable(_requests);

  int getMatchesCount(int requestId) => matchesCounts[requestId] ?? 0;

  /// استخرج رسالة الخطأ بأمان من أي نوع response
  String _extractError(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map) return data['message']?.toString() ?? fallback;
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }

  Future<void> fetchMatchesCount(int requestId) async {
    try {
      final response = await DioHelper.getData(path: 'Donors/match/$requestId');

      final dynamic dataField = response.data['data'];

      matchesCounts[requestId] = dataField is List ? dataField.length : 0;

      emit(ReceiverLoaded(List.from(_requests)));
    } on DioException {
      matchesCounts[requestId] = 0;
      emit(ReceiverLoaded(List.from(_requests)));
    } catch (_) {
      matchesCounts[requestId] = 0;
    }
  }

  Future<void> loadHistory({String? status}) async {
    emit(ReceiverLoading());
    try {
      final response = await DioHelper.getData(
        path: 'Requests/history',
        queryParameters: status != null ? {'status': status} : null,
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

      _requests = items;
      emit(ReceiverLoaded(items));

      for (final req in items) {
        if (req.status == 'Accepted') {
          fetchAcceptedDonor(req.requestId);
        } else if (req.status != 'Completed' && req.status != 'Cancelled') {
          fetchMatchesCount(req.requestId);
        }
      }
    } on DioException catch (e) {
      emit(ReceiverError(_extractError(e, 'Failed to load history')));
    } catch (e) {
      emit(ReceiverError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadActiveRequests({
    String? governorate,
    String? bloodType,
  }) async {
    emit(ReceiverLoading());
    try {
      final response = await DioHelper.getData(
        path: 'Requests/active',
        queryParameters: {
          if (governorate != null) 'governorate': governorate,
          if (bloodType != null) 'bloodType': bloodType,
          'pageSize': 20,
        },
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

      _requests = items;
      emit(ReceiverLoaded(items));

      for (final req in items) {
        if (req.status == 'Accepted') {
          fetchAcceptedDonor(req.requestId);
        } else if (req.status != 'Completed' && req.status != 'Cancelled') {
          fetchMatchesCount(req.requestId);
        }
      }
    } on DioException catch (e) {
      emit(ReceiverError(_extractError(e, 'Failed to load requests')));
    } catch (e) {
      emit(ReceiverError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> submitRequest({
    required String medicalReportText,
    required String bloodType,
    required int quantity,
    required String urgencyLevel,
    required int hospitalId,
  }) async {
    emit(ReceiverLoading());
    try {
      final response = await DioHelper.postData(
        path: 'Requests/submit',
        body: {
          'medicalReportText': medicalReportText,
          'bloodType': bloodType,
          'quantity': quantity,
          'urgencyLevel': urgencyLevel,
          'hospitalId': hospitalId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data?['data'] ?? response.data;
        emit(
          ReceiverSubmitSuccess(
            requestId: _toInt(data?['requestId']),
            detectedBloodType:
                data?['detectedBloodType']?.toString() ?? bloodType,
            urgencyLevel: data?['urgencyLevel']?.toString() ?? urgencyLevel,
          ),
        );
      } else {
        final msg = response.data is Map
            ? response.data['message']?.toString() ?? 'Submission failed'
            : 'Submission failed';
        emit(ReceiverError(msg));
      }
    } on DioException catch (e) {
      emit(ReceiverError(_extractError(e, 'Submission failed')));
    } catch (e) {
      emit(ReceiverError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> cancelRequest(int requestId) async {
    try {
      final response = await DioHelper.deleteData(
        path: 'Requests/$requestId/cancel',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _requests.removeWhere((e) => e.requestId == requestId);

        acceptedDonors.remove(requestId);
        requestStatuses.remove(requestId);
        matchesCounts.remove(requestId);

        emit(ReceiverLoaded(List.from(_requests)));
      }
    } on DioException catch (e) {
      emit(ReceiverError(_extractError(e, 'Cancel failed')));
    }
  }

  Future<void> acceptDonor({required int requestId, required int donorId}) async {
    try {
      await DioHelper.postData(
        path: 'Requests/$requestId/accept-donor',
        body: {'donorId': donorId},
      );
      fetchAcceptedDonor(requestId);
    } catch (e) {
      emit(ReceiverError('Failed to accept donor'));
    }
  }

  Future<void> fetchAcceptedDonor(int requestId) async {
    try {
      final resp = await DioHelper.getData(path: 'Requests/$requestId/donors');

      final dynamic data = resp.data['data'];

      if (data is List && data.isNotEmpty) {
        acceptedDonors[requestId] = data.first;
      } else if (data is Map) {
        acceptedDonors[requestId] = data;
      } else {
        acceptedDonors[requestId] = null;
      }

      emit(ReceiverLoaded(List.from(_requests)));
    } catch (_) {
      acceptedDonors[requestId] = null;
    }
  }

  Future<void> confirmDetection({
    required int requestId,
    required String bloodType,
  }) async {
    emit(ReceiverLoading());
    try {
      final response = await DioHelper.postData(
        path: 'Requests/confirm-detection',
        body: {'requestId': requestId, 'bloodType': bloodType},
      );
        if (response.statusCode == 200) {
          emit(ReceiverConfirmDetectionSuccess());
          // Refresh the active request list so the UI reflects the updated status
          await loadActiveRequests();
        } else {
        final msg = response.data is Map
            ? response.data['message']?.toString() ?? 'Confirmation failed'
            : 'Confirmation failed';
        emit(ReceiverError(msg));
      }
    } on DioException catch (e) {
      emit(ReceiverError(_extractError(e, 'Confirmation failed')));
    } catch (_) {
      emit(const ReceiverError('Unexpected error'));
    }
  }


      if (data is List && data.isNotEmpty) {
        acceptedDonors[requestId] = data.first;
      } else if (data is Map) {
        acceptedDonors[requestId] = data;
      } else {
        acceptedDonors[requestId] = null;
      }

      emit(ReceiverLoaded(List.from(_requests)));
    } catch (_) {
      acceptedDonors[requestId] = null;
    }
  }

  Future<void> loadAcceptedRequests() async {
    emit(ReceiverLoading());
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

      _requests = items;
      emit(ReceiverLoaded(items));
    } on DioException catch (e) {
      // Fallback if the endpoint does not exist on this backend version yet.
      // We will try fetching active requests and history, filtering by status.
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
            .toList();

        // Include accepted, ontheway, arrived
        _requests = items.where((req) {
          final s = req.status.toLowerCase();
          return s == 'accepted' || s == 'ontheway' || s == 'on_the_way' || s == 'arrived';
        }).toList();
        
        emit(ReceiverLoaded(List.from(_requests)));
      } catch (_) {
        emit(ReceiverError(_extractError(e, 'Failed to load accepted requests')));
      }
    } catch (e) {
      emit(ReceiverError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> fetchRequestStatus(int requestId) async {
    try {
      final resp = await DioHelper.getData(path: 'Requests/$requestId/status');

      final dynamic data = resp.data['data'];

      if (data is String) {
        requestStatuses[requestId] = data;
      } else {
        requestStatuses[requestId] = 'Pending';
      }

      emit(ReceiverLoaded(List.from(_requests)));
    } catch (_) {
      requestStatuses[requestId] = 'Pending';
    }
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
