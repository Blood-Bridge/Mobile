import 'package:blood_bridge/features/home/presentation/views/donor/donor_screen.dart';
import 'package:blood_bridge/features/map/presentation/cubit/map_cubit.dart';
import 'package:blood_bridge/features/map/presentation/cubit/map_state.dart';
import 'package:blood_bridge/features/map/presentation/view/widgets/bottom_panel.dart';
import 'package:blood_bridge/features/map/presentation/view/widgets/celebration_overlay.dart';
import 'package:blood_bridge/features/map/presentation/view/widgets/destination_marker.dart';
import 'package:blood_bridge/features/map/presentation/view/widgets/error_banner.dart';
import 'package:blood_bridge/features/map/presentation/view/widgets/map_marker.dart';
import 'package:blood_bridge/features/map/presentation/view/widgets/pulse_dot.dart';
import 'package:blood_bridge/features/map/presentation/view/widgets/topIcon_button.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreenBody extends StatefulWidget {
  const MapScreenBody();

  @override
  State<MapScreenBody> createState() => _MapScreenBodyState();
}

class _MapScreenBodyState extends State<MapScreenBody>
    with TickerProviderStateMixin {
  final MapController mapController = MapController();
  late final AnimationController _pulseController;
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openGoogleMapsDirections(LatLng me, LatLng dest) async {
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&origin=${me.latitude},${me.longitude}"
      "&destination=${dest.latitude},${dest.longitude}"
      "&travelmode=driving",
    );

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit, MapState>(
      listenWhen: (previous, current) =>
          previous.myLocation != current.myLocation ||
          previous.selected != current.selected ||
          previous.arrivedCelebration != current.arrivedCelebration ||
          previous.navigateAfterArrived != current.navigateAfterArrived,
      listener: (context, state) {
        if (state.arrivedCelebration && !state.navigateAfterArrived) {
          _controller
              .play(); // ✅ شغل الـ confetti فور ما arrivedCelebration = true
        }
        if (state.navigateAfterArrived) {
          // ✅ مفيش delay هنا خالص، الـ delay اتعملت في الـ cubit
          if (!context.mounted) return;
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(seconds: 2),
              pageBuilder: (_, __, ___) => DonorScreen(),
              transitionsBuilder: (_, animation, __, child) {
                final fade = Tween(begin: 0.0, end: 1.0).animate(animation);
                final scale = Tween(begin: 0.9, end: 1.0).animate(animation);
                return FadeTransition(
                  opacity: fade,
                  child: ScaleTransition(scale: scale, child: child),
                );
              },
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<MapCubit>();
        final center = state.myLocation ?? const LatLng(30.0444, 31.2357);

        return Scaffold(
          backgroundColor: const Color(0xFF0B0F14),
          body: SafeArea(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 14,
                    onTap: (_, __) {
                      cubit.clearSelection();
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.bloodbridge.fci',
                    ),

                    if (state.myLocation != null && cubit.initialTarget == null)
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: state.myLocation!,
                            radius: state.radiusMeters,
                            useRadiusInMeter: true,
                            color: const Color(0xFF2F80ED).withOpacity(0.10),
                            borderColor: const Color(
                              0xFF2F80ED,
                            ).withOpacity(0.35),
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),

                    if (state.routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: state.routePoints,
                            strokeWidth: 5,
                            color: const Color(0xFF2F80ED).withOpacity(0.85),
                          ),
                        ],
                      ),

                    MarkerLayer(
                      markers: [
                        if (state.myLocation != null)
                          Marker(
                            point: state.myLocation!,
                            width: 70,
                            height: 70,
                            child: PulseDot(controller: _pulseController),
                          ),

                        ...state.visibleRequests.map((r) {
                          final isSelected = state.selected == r;

                          return Marker(
                            point: r.point,
                            width: isSelected ? 74 : 54,
                            height: isSelected ? 90 : 54,
                            child: isSelected
                                ? DestinationMarker(
                                    color: r.color,
                                    onTap: () async {
                                      mapController.move(r.point, 14);
                                      await cubit.buildRouteTo(
                                        r,
                                        drawAnimated: true,
                                      );
                                    },
                                  )
                                : MapMarker(
                                    color: r.color,
                                    isSelected: isSelected,
                                    onTap: () async {
                                      mapController.move(r.point, 14);
                                      await cubit.buildRouteTo(
                                        r,
                                        drawAnimated: true,
                                      );
                                    },
                                  ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    blastDirectionality: BlastDirectionality.explosive,
                    confettiController: _controller,
                    emissionFrequency: 0.05,
                    numberOfParticles: 20,
                    gravity: 0.2,
                  ),
                ),
                if (state.arrivedCelebration) const CelebrationOverlay(),

                Positioned(
                  left: 16,
                  top: 16,
                  child: TopIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),

                Positioned(
                  right: 16,
                  top: 16,
                  child: TopIconButton(
                    icon: Icons.my_location_rounded,
                    onTap: () async {
                      await cubit.initMyLocation();
                      if (cubit.state.myLocation != null) {
                        mapController.move(cubit.state.myLocation!, 15.5);
                      }
                    },
                  ),
                ),

                if (state.error != null)
                  Positioned(
                    left: 12,
                    right: 12,
                    top: 70,
                    child: ErrorBanner(text: state.error!),
                  ),

                if (state.selected != null && state.myLocation != null)
                  Positioned(
                    right: 16,
                    top: 120,
                    child: FloatingActionButton(
                      heroTag: "gmaps",
                      onPressed: () => _openGoogleMapsDirections(
                        state.myLocation!,
                        state.selected!.point,
                      ),
                      child: const Icon(Icons.directions),
                    ),
                  ),

                if (cubit.initialTarget == null)
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: BottomPanel(
                      withinCount: state.withinCount,
                      km: (state.radiusMeters / 1000).round(),
                      infoText: cubit.routeInfoText(),
                      hasSelection:
                          state.selected != null || cubit.initialTarget != null,
                      trackingEnabled: state.trackingEnabled,
                      onAccept: cubit.startTrackingEvery3s,
                      onStop: cubit.stopTracking,
                      onArrived: cubit.onArrived,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
