import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/features/map/presentation/view/widgets/req_marker.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';
import '../services/map_cache_service.dart';
import '../services/routing_service.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({
    required this.locationService,
    required this.cacheService,
    required this.routingService,
    this.initialTarget,
    this.autoRouteOnOpen = false,
    this.instantRouteOnOpen = true,
    this.onLocationUpdate,
    LatLng? donorLocation,
  }) : super(MapState.initial(donorLocation: donorLocation));

  final LocationService locationService;
  final MapCacheService cacheService;
  final RoutingService routingService;

  final LatLng? initialTarget;
  final bool autoRouteOnOpen;
  final bool instantRouteOnOpen;

  final Future<void> Function(LatLng location)? onLocationUpdate;

  static const double radiusStepMeters = 1000;
  static const double radiusMaxMeters = 10000;

  Timer? _radiusTimer;
  Timer? _trackTimer;

  LatLng? _lastSentLocation;

  Future<void> bootstrap() async {
    await cacheService.init();

    final cached = cacheService.readCachedLocation();

    if (cached != null) {
      emit(state.copyWith(myLocation: cached, clearError: true));

      _recalculateWithin();
    }

    await Future.wait([initMyLocation(), fetchActiveRequests()]);

    if (state.myLocation != null && initialTarget == null) {
      startRadiusGrowth();
    }
  }

  Future<void> fetchActiveRequests() async {
    try {
      final role = HiveHelper.getUserRole()?.toLowerCase();

      final isRecipient = role == 'recipient';

      if (isRecipient) {
        final response = await DioHelper.getData(
          path: 'Donors/get-all',
          queryParameters: {'pageSize': 50},
        );

        final data = response.data['data'];

        List<dynamic> items = [];

        if (data is List) {
          items = data;
        } else if (data is Map) {
          items = data['items'] ?? [];
        }

        final markers = items.map((e) {
          final id = e['donorId']?.toString() ?? '';

          final bloodType = e['bloodType']?.toString() ?? '';

          final lat = (e['latitude'] as num?)?.toDouble() ?? 30.0444;

          final lng = (e['longitude'] as num?)?.toDouble() ?? 31.2357;

          return ReqMarker(id, LatLng(lat, lng), Colors.blue, bloodType);
        }).toList();

        emit(state.copyWith(requests: markers));

        _recalculateWithin();
      } else {
        final response = await DioHelper.getData(
          path: 'Requests/active',
          queryParameters: {'pageSize': 50},
        );

        final data = response.data['data'];

        List<dynamic> items = [];

        if (data is List) {
          items = data;
        } else if (data is Map) {
          items = data['items'] ?? [];
        }

        final markers = items.asMap().entries.map((entry) {
          final index = entry.key;
          final e = entry.value;

          final id = e['requestId']?.toString() ?? '';

          final status = e['status']?.toString() ?? '';

          return ReqMarker(
            id,
            LatLng(30.0444 + (index * 0.003), 31.2357 + (index * 0.002)),
            _colorForStatus(status),
            status,
          );
        }).toList();

        emit(state.copyWith(requests: markers));

        _recalculateWithin();
      }
    } catch (e) {
      debugPrint('Map Error: $e');
    }
  }

  static Color _colorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'open':
      case 'analyzing':
        return const Color(0xFFFF3B30);

      case 'accepted':
        return const Color(0xFF34C759);

      case 'ontheway':
        return const Color(0xFF007AFF);

      default:
        return const Color(0xFF2A2F36);
    }
  }

  Future<void> initMyLocation() async {
    emit(state.copyWith(isLoadingLocation: true, clearError: true));

    try {
      final loc = await locationService.getCurrentLatLng();

      await cacheService.saveCachedLocation(loc);

      emit(
        state.copyWith(
          myLocation: loc,
          isLoadingLocation: false,
          clearError: true,
        ),
      );

      _recalculateWithin();
    } catch (e) {
      emit(state.copyWith(isLoadingLocation: false, error: e.toString()));
    }
  }

  void startRadiusGrowth() {
    _radiusTimer?.cancel();

    _radiusTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (state.radiusMeters >= radiusMaxMeters) return;

      final nextRadius = (state.radiusMeters + radiusStepMeters).clamp(
        500.0,
        radiusMaxMeters,
      );

      emit(state.copyWith(radiusMeters: nextRadius));

      _recalculateWithin();
    });
  }

  void _recalculateWithin() {
    final me = state.myLocation;

    if (me == null) return;

    final visible = state.requests.where((r) {
      final distance = locationService.distanceBetween(me, r.point);

      return distance <= state.radiusMeters;
    }).toList();

    emit(state.copyWith(visibleRequests: visible, withinCount: visible.length));
  }

  Future<void> buildRouteTo(ReqMarker target) async {
    final me = state.myLocation;

    if (me == null) return;

    emit(state.copyWith(selected: target, isRouting: true, clearError: true));

    try {
      final result = await routingService.getDrivingRoute(
        from: me,
        to: target.point,
      );

      emit(
        state.copyWith(
          isRouting: false,
          routePoints: result.points,
          routeDistanceMeters: result.distanceMeters,
          routeDurationSeconds: result.durationSeconds,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isRouting: false, error: 'Route error: $e'));
    }
  }

  Future<void> refreshMarkers() async {
    await fetchActiveRequests();
  }

  void startTrackingEvery15s() {
    _trackTimer?.cancel();

    emit(state.copyWith(trackingEnabled: true, clearError: true));

    _trackTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      try {
        final loc = await locationService.getCurrentLatLng();

        await cacheService.saveCachedLocation(loc);

        if (_lastSentLocation == null ||
            locationService.distanceBetween(_lastSentLocation!, loc) > 50) {
          _lastSentLocation = loc;

          await _sendLocationToServer(loc);

          if (onLocationUpdate != null) {
            await onLocationUpdate!(loc);
          }
        }

        emit(state.copyWith(myLocation: loc, clearError: true));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });
  }

  Future<void> _sendLocationToServer(LatLng loc) async {
    try {
      await DioHelper.patchData(
        path: 'Users/location',
        body: {'latitude': loc.latitude, 'longitude': loc.longitude},
      );
    } catch (e) {
      debugPrint('Location update failed: $e');
    }
  }

  void stopTracking() {
    _trackTimer?.cancel();

    emit(state.copyWith(trackingEnabled: false));
  }

  void clearSelection() {
    emit(
      state.copyWith(
        clearSelected: true,
        routePoints: [],
        isRouting: false,
        clearRouteMeta: true,
      ),
    );
  }

  String routeInfoText() {
    if (state.myLocation == null) {
      return 'Getting your location...';
    }

    if (state.isRouting) {
      return 'Calculating route...';
    }

    if (state.selected == null) {
      return 'Tap a marker to see route & ETA';
    }

    if (state.routeDistanceMeters == null ||
        state.routeDurationSeconds == null) {
      return 'Route not ready';
    }

    final mins = (state.routeDurationSeconds! / 60).round();

    final km = state.routeDistanceMeters! / 1000;

    return 'ETA: $mins min • Distance: ${km.toStringAsFixed(1)} km';
  }

  Future<void> onArrived() async {
    if (state.selected == null) return;

    final km = (state.routeDistanceMeters ?? 0) / 1000;

    final mins = ((state.routeDurationSeconds ?? 0) / 60).round();

    _trackTimer?.cancel();
    _radiusTimer?.cancel();

    emit(
      state.copyWith(
        routePoints: [],
        trackingEnabled: false,
        clearSelected: true,
        arrivedCelebration: true,
        navigateAfterArrived: false,
        finalDistanceKm: km,
        finalDurationMin: mins,
      ),
    );

    await Future.delayed(const Duration(seconds: 3));

    if (isClosed) return;

    emit(state.copyWith(navigateAfterArrived: true));
  }

  @override
  Future<void> close() {
    _radiusTimer?.cancel();
    _trackTimer?.cancel();

    return super.close();
  }
}
