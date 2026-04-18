import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class RouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;

  const RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}

class RoutingService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  );

  Future<RouteResult> getDrivingRoute({
    required LatLng from,
    required LatLng to,
  }) async {
    final url =
        "https://router.project-osrm.org/route/v1/driving/"
        "${from.longitude},${from.latitude};${to.longitude},${to.latitude}";

    final res = await dio.get(
      url,
      queryParameters: const {"overview": "full", "geometries": "geojson"},
    );

    final data = (res.data as Map).cast<String, dynamic>();
    final routes = (data["routes"] as List);

    if (routes.isEmpty) {
      throw Exception("No route found");
    }

    final first = (routes.first as Map).cast<String, dynamic>();
    final distance = (first["distance"] as num).toDouble();
    final duration = (first["duration"] as num).toDouble();

    final geometry = (first["geometry"] as Map).cast<String, dynamic>();
    final coords = (geometry["coordinates"] as List);

    final points = coords.map<LatLng>((c) {
      final lon = (c[0] as num).toDouble();
      final lat = (c[1] as num).toDouble();
      return LatLng(lat, lon);
    }).toList();

    return RouteResult(
      points: points,
      distanceMeters: distance,
      durationSeconds: duration,
    );
  }
}
