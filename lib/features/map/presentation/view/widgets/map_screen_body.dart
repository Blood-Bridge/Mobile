import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/donor_screen.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/cubit/cubit/donor_cubit.dart';
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
  const MapScreenBody({super.key});

  @override
  State<MapScreenBody> createState() => _MapScreenBodyState();
}

class _MapScreenBodyState extends State<MapScreenBody>
    with TickerProviderStateMixin {
  final MapController mapController = MapController();
  late final AnimationController _pulseController;
  late final ConfettiController _confettiController;
  late final MapCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<MapCubit>();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.bootstrap();
    });
  }

  @override
  void dispose() {
    _cubit.stopTracking();
    _pulseController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _onAccept() {
    final selected = _cubit.state.selected;
    if (selected == null) return;
    final requestId = int.tryParse(selected.id) ?? 0;
    if (requestId == 0) return;
    context.read<DonorCubit>().acceptRequest(requestId, fromMap: true);
  }

  Future<void> _openGoogleMaps(LatLng me, LatLng dest) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${me.latitude},${me.longitude}'
      '&destination=${dest.latitude},${dest.longitude}'
      '&travelmode=driving',
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DonorCubit, DonorState>(
      listener: (context, donorState) {
        if (donorState is DonorAccepted) {
          // Backend confirmed → now start tracking
          _cubit.startTrackingEvery15s();
        } else if (donorState is DonorsError) {
          showSnackBar('Error', donorState.message, SnackbarType.error);
        }
      },
      child: BlocConsumer<MapCubit, MapState>(
        listenWhen: (prev, curr) =>
            prev.arrivedCelebration != curr.arrivedCelebration ||
            prev.navigateAfterArrived != curr.navigateAfterArrived,
        listener: (context, state) {
          if (state.arrivedCelebration && !state.navigateAfterArrived) {
            _confettiController.play();
          }
          if (state.navigateAfterArrived && context.mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                transitionDuration: const Duration(seconds: 2),
                pageBuilder: (_, __, ___) => const DonorScreen(),
                transitionsBuilder: (_, animation, __, child) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween(begin: 0.9, end: 1.0).animate(animation),
                    child: child,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
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
                      onTap: (_, __) => _cubit.clearSelection(),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                        subdomains: const ['a', 'b', 'c', 'd'],
                        userAgentPackageName: 'com.bloodbridge.fci',
                      ),
                      if (state.myLocation != null &&
                          _cubit.initialTarget == null)
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: state.myLocation!,
                              radius: state.radiusMeters,
                              useRadiusInMeter: true,
                              color: const Color(
                                0xFF2F80ED,
                              ).withValues(alpha: 0.10),
                              borderColor: const Color(
                                0xFF2F80ED,
                              ).withValues(alpha: 0.35),
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
                              color: const Color(
                                0xFF2F80ED,
                              ).withValues(alpha: 0.85),
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
                          if (state.donorLocation != null)
                            Marker(
                              point: state.donorLocation!,
                              width: 60,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.directions_car_rounded,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
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
                                        await _cubit.buildRouteTo(r);
                                      },
                                    )
                                  : MapMarker(
                                      color: r.color,
                                      isSelected: isSelected,
                                      onTap: () async {
                                        mapController.move(r.point, 14);
                                        await _cubit.buildRouteTo(r);
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
                      confettiController: _confettiController,
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
                        await _cubit.initMyLocation();
                        if (_cubit.state.myLocation != null) {
                          mapController.move(_cubit.state.myLocation!, 15.5);
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
                        heroTag: 'gmaps',
                        onPressed: () => _openGoogleMaps(
                          state.myLocation!,
                          state.selected!.point,
                        ),
                        child: const Icon(Icons.directions),
                      ),
                    ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: BottomPanel(
                      withinCount: state.withinCount,
                      km: (state.radiusMeters / 1000).round(),
                      infoText: _cubit.routeInfoText(),
                      hasSelection: state.selected != null,
                      trackingEnabled: state.trackingEnabled,
                      onAccept: _onAccept,
                      onStop: _cubit.stopTracking,
                      onArrived: _cubit.onArrived,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
