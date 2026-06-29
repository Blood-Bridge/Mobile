import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:blood_bridge/l10n/app_localizations.dart';
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
import 'package:blood_bridge/features/map/presentation/view/widgets/req_marker.dart';
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

  Future<void> _contactDonorWithNumber(String phone) async {
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showSnackBar('خطأ', 'تعذر الاتصال', SnackbarType.error);
    }
  }

  void _showMarkerDetails(ReqMarker marker) {
    final bool isReceiver =
        _cubit.state.userRole == 'receiver' ||
        _cubit.state.userRole == 'recipient' ||
        _cubit.state.userRole == 'hospital';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: const BoxDecoration(
            color: Color(0xFF0B0F14),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isReceiver
                      ? AppLocalizations.of(context)!.donorDetails
                      : AppLocalizations.of(context)!.requestDetails,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Divider(color: Colors.white24, height: 30),

                _buildDetailRow(Icons.person, "Name", marker.name ?? "Unknown"),
                if (marker.bloodType != null)
                  _buildDetailRow(
                    Icons.bloodtype,
                    "Blood Type",
                    marker.bloodType!,
                  ),
                if (marker.phone != null)
                  _buildDetailRow(Icons.phone, "Phone", marker.phone!),

                const Spacer(),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _cubit.buildRouteTo(marker);
                        },
                        icon: const Icon(Icons.directions),
                        label: Text(AppLocalizations.of(context)!.showRoute),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (isReceiver && marker.phone != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _contactDonorWithNumber(marker.phone!);
                          },
                          icon: const Icon(Icons.phone),
                          label: Text(AppLocalizations.of(context)!.call),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 26),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DonorCubit, DonorState>(
      listener: (context, donorState) {
        if (donorState is DonorAccepted) {
          _cubit.startTrackingEvery15s();
        } else if (donorState is DonorsError) {
          showSnackBar('Error', donorState.message, SnackbarType.error);
        }
      },
      child: BlocConsumer<MapCubit, MapState>(
        listenWhen: (prev, curr) =>
            prev.arrivedCelebration != curr.arrivedCelebration ||
            prev.navigateAfterArrived != curr.navigateAfterArrived ||
            prev.activeDonor != curr.activeDonor,
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
          final bool isReceiver =
              state.userRole == 'receiver' ||
              state.userRole == 'recipient' ||
              state.userRole == 'hospital';

          // Auto Route
          if (isReceiver &&
              state.activeDonor != null &&
              state.routePoints.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _cubit.buildRouteTo(state.activeDonor!);
            });
          }

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
                        // لا يمسح الـ selection أثناء الـ Tracking
                        if (!state.trackingEnabled) {
                          _cubit.clearSelection();
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                        subdomains: const ['a', 'b', 'c', 'd'],
                        userAgentPackageName: 'com.bloodbridge.fci',
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

                          // Receiver Mode: Active Donor Only
                          if (isReceiver && state.activeDonor != null)
                            Marker(
                              point: state.activeDonor!.point,
                              width: 74,
                              height: 90,
                              child: DestinationMarker(
                                color: state.activeDonor!.color,
                                onTap: () async {
                                  mapController.move(
                                    state.activeDonor!.point,
                                    14,
                                  );
                                  await _cubit.buildRouteTo(state.activeDonor!);
                                  _showMarkerDetails(state.activeDonor!);
                                },
                              ),
                            ),

                          // Donor Mode: All Requests
                          if (!isReceiver)
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
                                          _showMarkerDetails(r);
                                        },
                                      )
                                    : MapMarker(
                                        color: r.color,
                                        isSelected: isSelected,
                                        onTap: () async {
                                          mapController.move(r.point, 14);
                                          await _cubit.buildRouteTo(r);
                                          _showMarkerDetails(r);
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

                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: BottomPanel(
                      withinCount: state.withinCount,
                      km: (state.radiusMeters / 1000).round(),
                      infoText: _cubit.routeInfoText(context),
                      hasSelection: state.selected != null,
                      trackingEnabled: state.trackingEnabled,
                      onAccept: _onAccept,
                      onStop: _cubit.stopTracking,
                      onArrived: _cubit.onArrived,
                      onContact: state.selected?.phone != null
                          ? () =>
                                _contactDonorWithNumber(state.selected!.phone!)
                          : null,
                      onNavigate:
                          state.selected != null && state.myLocation != null
                          ? () => _openGoogleMaps(
                              state.myLocation!,
                              state.selected!.point,
                            )
                          : null,
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
