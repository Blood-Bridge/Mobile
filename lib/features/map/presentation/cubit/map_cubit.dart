import 'dart:async';

import 'package:bloc/bloc.dart';
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
  }) : super(MapState.initial());

  final LocationService locationService;
  final MapCacheService cacheService;
  final RoutingService routingService;

  final LatLng? initialTarget;
  final bool autoRouteOnOpen;
  final bool instantRouteOnOpen;

  static const double radiusStepMeters = 1000;
  static const double radiusMaxMeters = 10000;

  Timer? _radiusTimer;
  Timer? _routeDrawTimer;
  Timer? _trackTimer;

  LatLng? _lastRoutedFrom;
  List<LatLng> _routeFull = [];

  final List<ReqMarker> _mockRequests = const [
    ReqMarker("1", LatLng(30.0460, 31.2335), Color(0xFFE58B93), "Critical"),
    ReqMarker("2", LatLng(30.0431, 31.2380), Color(0xFFF6B400), "Urgent"),
    ReqMarker("3", LatLng(30.0455, 31.2405), Color(0xFF77B47C), "Available"),
    ReqMarker("4", LatLng(30.0422, 31.2310), Color(0xFF77B47C), "Available"),
    ReqMarker("5", LatLng(30.0410, 31.2362), Color(0xFF2A2F36), "Other"),
  ];

  Future<void> bootstrap() async {
    await cacheService.init();

    emit(state.copyWith(requests: _mockRequests));

    final cached = cacheService.readCachedLocation();
    if (cached != null) {
      emit(state.copyWith(myLocation: cached, clearError: true));
      _recalculateWithin();
    }

    await initMyLocation();

    if (state.myLocation != null && initialTarget == null) {
      startRadiusGrowth();
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

      if (autoRouteOnOpen) {
        final target = ReqMarker(
          "initialTarget",
          initialTarget!,
          const Color(0xFF77B47C),
          "Target",
        );

        await buildRouteTo(target, drawAnimated: !instantRouteOnOpen);
      }
    } catch (e) {
      emit(state.copyWith(isLoadingLocation: false, error: e.toString()));
    }
  }

  Future<void> onArrived() async {
    if (state.selected == null) return;

    final loc = await locationService.getCurrentLatLng();
    await cacheService.saveCachedLocation(loc);

    _trackTimer?.cancel();
    _routeDrawTimer?.cancel();
    _radiusTimer?.cancel();

    final km = (state.routeDistanceMeters ?? 0) / 1000;
    final mins = ((state.routeDurationSeconds ?? 0) / 60).round();

    // ✅ الأول: celebration بس، navigate = false
    emit(
      state.copyWith(
        routePoints: [],
        trackingEnabled: false,
        clearSelected: true,
        arrivedCelebration: true,
        navigateAfterArrived: false, // ✅ مش هنعمل navigate دلوقتي
        finalDistanceKm: km,
        finalDurationMin: mins,
      ),
    );

    // ✅ استنى 3 ثواني عشان الـ confetti يظهر
    await Future.delayed(const Duration(seconds: 3));

    if (isClosed) return; // ✅ مهم

    // ✅ بعدين: navigate
    emit(state.copyWith(navigateAfterArrived: true));
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
      final d = locationService.distanceBetween(me, r.point);
      return d <= state.radiusMeters;
    }).toList();

    ReqMarker? nextSelected = state.selected;
    bool shouldClearRoute = false;

    if (nextSelected != null && !visible.contains(nextSelected)) {
      final isInitialTarget =
          initialTarget != null &&
          nextSelected.point.latitude == initialTarget!.latitude &&
          nextSelected.point.longitude == initialTarget!.longitude;

      if (!isInitialTarget) {
        nextSelected = null;
        shouldClearRoute = true;
      }
    }

    emit(
      state.copyWith(
        visibleRequests: visible,
        withinCount: visible.length,
        selected: nextSelected,
        clearSelected: nextSelected == null,
        routePoints: shouldClearRoute ? [] : state.routePoints,
        isRouting: shouldClearRoute ? false : state.isRouting,
        clearRouteMeta: shouldClearRoute,
      ),
    );
  }

  void clearRoute() {
    _routeDrawTimer?.cancel();
    _routeFull = [];

    emit(
      state.copyWith(routePoints: [], isRouting: false, clearRouteMeta: true),
    );
  }

  void clearSelection() {
    if (initialTarget != null) return;
    emit(state.copyWith(clearSelected: true));
    clearRoute();
  }

  Future<void> buildRouteTo(
    ReqMarker target, {
    required bool drawAnimated,
  }) async {
    final me = state.myLocation;
    if (me == null) return;

    _routeDrawTimer?.cancel();

    emit(
      state.copyWith(
        selected: target,
        isRouting: true,
        clearRouteMeta: true,
        clearError: true,
        routePoints: drawAnimated ? [] : state.routePoints,
      ),
    );

    try {
      final result = await routingService.getDrivingRoute(
        from: me,
        to: target.point,
      );

      if (!drawAnimated || result.points.length < 2) {
        emit(
          state.copyWith(
            isRouting: false,
            routePoints: result.points,
            routeDistanceMeters: result.distanceMeters,
            routeDurationSeconds: result.durationSeconds,
          ),
        );
        return;
      }

      _routeFull = result.points;

      emit(
        state.copyWith(
          isRouting: false,
          routePoints: [result.points.first],
          routeDistanceMeters: result.distanceMeters,
          routeDurationSeconds: result.durationSeconds,
        ),
      );

      int i = 1;
      _routeDrawTimer = Timer.periodic(const Duration(milliseconds: 16), (t) {
        if (isClosed) {
          t.cancel();
          return;
        }

        if (i >= _routeFull.length) {
          t.cancel();
          return;
        }

        final updated = List<LatLng>.from(state.routePoints)
          ..add(_routeFull[i]);
        emit(state.copyWith(routePoints: updated));
        i++;
      });
    } catch (e) {
      emit(state.copyWith(isRouting: false, error: "Route error: $e"));
    }
  }

  void startTrackingEvery3s() {
    _trackTimer?.cancel();

    final selected = state.selected;
    if (selected == null) return;

    emit(
      state.copyWith(
        trackingEnabled: true,
        requests: [selected], // 👈 مهم
        visibleRequests: [selected], // 👈 مهم
      ),
    );

    _trackTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      try {
        final loc = await locationService.getCurrentLatLng();
        await cacheService.saveCachedLocation(loc);

        emit(state.copyWith(myLocation: loc, clearError: true));

        final target = state.selected;
        if (target != null) {
          final remaining = locationService.distanceBetween(target.point, loc);

          // 👇 Auto Arrived
          if (remaining <= 15) {
            await onArrived();
            return;
          }
          final last = _lastRoutedFrom;
          final moved = last == null
              ? 9999.0
              : locationService.distanceBetween(last, loc);

          if (moved >= 20) {
            _lastRoutedFrom = loc;
            await buildRouteTo(target, drawAnimated: false);
          }
        }
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });
  }

  void stopTracking() {
    _trackTimer?.cancel();
    emit(state.copyWith(trackingEnabled: false));
  }

  String routeInfoText() {
    if (state.myLocation == null) return "Getting your location...";
    if (state.isRouting) return "Calculating route...";
    if (state.selected == null && initialTarget == null) {
      return "Tap a marker to see route & ETA";
    }
    if (state.routeDistanceMeters == null ||
        state.routeDurationSeconds == null) {
      return "Route not ready";
    }

    final mins = (state.routeDurationSeconds! / 60).round();
    final km = state.routeDistanceMeters! / 1000.0;
    return "ETA: $mins min • Distance: ${km.toStringAsFixed(1)} km";
  }

  @override
  Future<void> close() {
    _radiusTimer?.cancel();
    _routeDrawTimer?.cancel();
    _trackTimer?.cancel();
    return super.close();
  }
}
