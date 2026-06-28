import 'package:bloc/bloc.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:dio/dio.dart';

part 'hospital_dashboard_state.dart';

class HospitalDashboardCubit extends Cubit<HospitalDashboardState> {
  HospitalDashboardCubit() : super(HospitalDashboardState.initial());

  Future<void> fetchAll() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await Future.wait([
        _fetchInventory(),
        _fetchActiveRequests(),
        _fetchNearbyDonors(),
      ]);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // ── 1. Blood Inventory ─────────────────────────────
  Future<void> _fetchInventory() async {
    try {
      final response = await DioHelper.getData(path: 'Hospital/inventory');

      if (response.statusCode == 200) {
        final raw = response.data?['data'];

        final list = raw is List ? raw : [];

        final items = list
            .whereType<Map<String, dynamic>>()
            .map(BloodInventoryItem.fromMap)
            .toList();

        final total = items.fold<int>(
          0,
          (sum, item) => sum + (item.units ?? 0),
        );

        print('✅ Inventory Loaded: ${items.length} items'); // للdebug

        emit(state.copyWith(bloodInventory: items, availableBloodUnits: total));
      }
    } on DioException catch (e) {
      _handleDioError(e, 'Inventory');
    } catch (e) {
      print('Inventory Error: $e');
    }
  }

  // ── 2. Active Requests ─────────────────────────────
  Future<void> _fetchActiveRequests() async {
    try {
      final response = await DioHelper.getData(path: 'Requests/active');

      if (response.statusCode == 200) {
        final raw = response.data?['data'];
        final List items = raw is List
            ? raw
            : (raw is Map ? (raw['items'] ?? raw['data'] ?? []) : []);

        final requests = items
            .whereType<Map<String, dynamic>>()
            .map(ActiveRequest.fromMap)
            .toList();

        emit(
          state.copyWith(
            activeRequests: requests,
            pendingRequests: requests.length,
          ),
        );
      }
    } on DioException catch (e) {
      _handleDioError(e, 'Active Requests');
    }
  }

  // ── 3. Nearby Donors ─────────────────────────────
  Future<void> _fetchNearbyDonors() async {
    try {
      final response = await DioHelper.getData(path: 'Donors/get-all');

      if (response.statusCode == 200) {
        final raw = response.data?['data'];
        final List items = raw is List
            ? raw
            : (raw is Map ? (raw['items'] ?? raw['donors'] ?? []) : []);

        final donors = items
            .whereType<Map<String, dynamic>>()
            .map(NearbyDonor.fromMap)
            .toList();

        donors.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

        emit(state.copyWith(nearbyDonors: donors, activeDonors: donors.length));
      }
    } on DioException catch (e) {
      _handleDioError(e, 'Nearby Donors');
    }
  }

  // ── Helper to safely handle Dio Errors ─────────────────────────────
  void _handleDioError(DioException e, String operation) {
    String errorMsg = 'Failed to load $operation';

    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        errorMsg =
            data['message']?.toString() ??
            data['error']?.toString() ??
            errorMsg;
      } else if (data is String) {
        errorMsg = data;
      }
    }

    print('$operation Error: $errorMsg');
    // You can emit error if needed
  }

  // Update Inventory
  Future<void> updateBloodInventory(
    List<Map<String, dynamic>> inventory,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await DioHelper.putData(
        path: 'Hospital/inventory',
        body: inventory,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(isLoading: false));
        await fetchAll();
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: _extractMessage(response.data),
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: _extractMessage(e.response?.data),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  String _extractMessage(dynamic data) {
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          'Operation failed';
    } else if (data is String) {
      return data;
    }
    return 'Operation failed';
  }
}
