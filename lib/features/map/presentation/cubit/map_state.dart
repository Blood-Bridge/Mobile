import 'package:blood_bridge/features/map/presentation/view/widgets/req_marker.dart';
import 'package:latlong2/latlong.dart';

class MapState {
  final LatLng? myLocation;
  final bool isLoadingLocation;
  final String? error;

  final List<ReqMarker> requests;
  final List<ReqMarker> visibleRequests;
  final ReqMarker? selected;

  final double radiusMeters;
  final int withinCount;

  final List<LatLng> routePoints;
  final bool isRouting;

  final double? routeDistanceMeters;
  final double? routeDurationSeconds;

  final bool trackingEnabled;

  final bool arrivedCelebration;
  final bool navigateAfterArrived;

  // 👇 Stats
  final double? finalDistanceKm;
  final int? finalDurationMin;

  // Live location of the donor who accepted the request (receiver side)
  final LatLng? donorLocation;

  MapState({
    this.myLocation,
    this.isLoadingLocation = false,
    this.error,
    this.requests = const [],
    this.visibleRequests = const [],
    this.selected,
    this.radiusMeters = 500,
    this.withinCount = 0,
    this.routePoints = const [],
    this.isRouting = false,
    this.routeDistanceMeters,
    this.routeDurationSeconds,
    this.trackingEnabled = false,
    this.arrivedCelebration = false,
    this.navigateAfterArrived = false,
    this.finalDistanceKm,
    this.finalDurationMin,
    this.donorLocation,
  });

  factory MapState.initial({LatLng? donorLocation}) => MapState(donorLocation: donorLocation);

  MapState copyWith({
    LatLng? myLocation,
    bool? isLoadingLocation,
    String? error,
    List<ReqMarker>? requests,
    List<ReqMarker>? visibleRequests,
    ReqMarker? selected,
    bool clearSelected = false,
    double? radiusMeters,
    int? withinCount,
    List<LatLng>? routePoints,
    bool? isRouting,
    double? routeDistanceMeters,
    double? routeDurationSeconds,
    bool clearRouteMeta = false,
    bool clearError = false,
    bool? trackingEnabled,
    bool? arrivedCelebration,
    bool? navigateAfterArrived,
    double? finalDistanceKm,
    int? finalDurationMin,
    LatLng? donorLocation,
  }) {
    return MapState(
      myLocation: myLocation ?? this.myLocation,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      error: clearError ? null : (error ?? this.error),
      requests: requests ?? this.requests,
      visibleRequests: visibleRequests ?? this.visibleRequests,
      selected: clearSelected ? null : (selected ?? this.selected),
      radiusMeters: radiusMeters ?? this.radiusMeters,
      withinCount: withinCount ?? this.withinCount,
      routePoints: routePoints ?? this.routePoints,
      isRouting: isRouting ?? this.isRouting,
      routeDistanceMeters: clearRouteMeta
          ? null
          : (routeDistanceMeters ?? this.routeDistanceMeters),
      routeDurationSeconds: clearRouteMeta
          ? null
          : (routeDurationSeconds ?? this.routeDurationSeconds),
      trackingEnabled: trackingEnabled ?? this.trackingEnabled,
      arrivedCelebration: arrivedCelebration ?? this.arrivedCelebration,
      navigateAfterArrived: navigateAfterArrived ?? this.navigateAfterArrived,
      finalDistanceKm: finalDistanceKm ?? this.finalDistanceKm,
      finalDurationMin: finalDurationMin ?? this.finalDurationMin,
      donorLocation: donorLocation ?? this.donorLocation,
    );
  }
}
