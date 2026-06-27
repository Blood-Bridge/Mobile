import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  LatLng? _lastLocation;
  StreamSubscription<Position>? _subscription;

  // =========================
  // 📍 Current Location (زي ما هو)
  // =========================
  Future<LatLng> getCurrentLatLng() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied.");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Enable location from settings.");
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(pos.latitude, pos.longitude);
  }

  // =========================
  // 🚀 Start Listening (🔥 المهم)
  // =========================
  void startListening({required Function(LatLng location) onLocationChanged}) {
    _subscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 100, // 🔥 كل 100 متر
          ),
        ).listen((Position pos) {
          final newLocation = LatLng(pos.latitude, pos.longitude);

          if (_shouldSend(newLocation)) {
            _lastLocation = newLocation;
            onLocationChanged(newLocation);
          }
        });
  }

  // =========================
  // 🧠 فلترة الحركة
  // =========================
  bool _shouldSend(LatLng newLocation) {
    if (_lastLocation == null) return true;

    final distance = Geolocator.distanceBetween(
      _lastLocation!.latitude,
      _lastLocation!.longitude,
      newLocation.latitude,
      newLocation.longitude,
    );

    return distance > 100; // 🔥 أقل من 100 متر = تجاهل
  }

  // =========================
  // 🛑 Stop
  // =========================
  void stopListening() {
    _subscription?.cancel();
  }

  // =========================
  // 📏 Distance
  // =========================
  double distanceBetween(LatLng a, LatLng b) {
    return Geolocator.distanceBetween(
      a.latitude,
      a.longitude,
      b.latitude,
      b.longitude,
    );
  }
}
