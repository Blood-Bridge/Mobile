/// Represents the app-wide connectivity/location status that the
/// [ConnectivityStatusCubit] tracks and the overlay reacts to.
enum AppStatus {
  /// Everything is fine — show the normal app content.
  ok,

  /// No internet connection.
  noConnection,

  /// Location services are disabled or permission was denied.
  locationDisabled,
}

class ConnectivityStatusEntity {
  const ConnectivityStatusEntity({
    required this.status,
    required this.hasInternet,
    required this.isLocationEnabled,
  });

  final AppStatus status;
  final bool hasInternet;
  final bool isLocationEnabled;
}
