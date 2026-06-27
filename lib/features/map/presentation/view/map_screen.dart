import 'package:blood_bridge/features/map/presentation/cubit/map_cubit.dart';
import 'package:blood_bridge/features/map/presentation/services/location_service.dart';
import 'package:blood_bridge/features/map/presentation/services/map_cache_service.dart';
import 'package:blood_bridge/features/map/presentation/services/routing_service.dart';
import 'package:blood_bridge/features/map/presentation/view/widgets/map_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
    this.initialTarget,
    this.autoRouteOnOpen = false,
    this.instantRouteOnOpen = true,
    this.donorLocation,
  });

  final LatLng? initialTarget;
  final bool autoRouteOnOpen;
  final bool instantRouteOnOpen;
  final LatLng? donorLocation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapCubit(
        locationService: LocationService(),
        cacheService: MapCacheService(),
        routingService: RoutingService(),
        initialTarget: initialTarget,
        autoRouteOnOpen: autoRouteOnOpen,
        instantRouteOnOpen: instantRouteOnOpen,
        donorLocation: donorLocation,
      )..bootstrap(),
      child: const MapScreenBody(),
    );
  }
}
