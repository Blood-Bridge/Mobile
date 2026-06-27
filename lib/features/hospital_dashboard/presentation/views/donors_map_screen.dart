import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/hospital_dashboard/presentation/cubit/hospital_dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorsMapScreen extends StatefulWidget {
  final List<NearbyDonor> donors;

  const DonorsMapScreen({super.key, required this.donors});

  @override
  State<DonorsMapScreen> createState() => _DonorsMapScreenState();
}

class _DonorsMapScreenState extends State<DonorsMapScreen> {
  final MapController _mapController = MapController();
  NearbyDonor? _selectedDonor;

  List<NearbyDonor> get _validDonors => widget.donors
      .where((d) => d.latitude != null && d.longitude != null)
      .where((d) => d.latitude! != 0.0 || d.longitude! != 0.0)
      .toList();

  LatLng get _center {
    if (_validDonors.isEmpty) return const LatLng(30.0444, 31.2357); // Cairo default
    final lat = _validDonors.map((d) => d.latitude!).reduce((a, b) => a + b) /
        _validDonors.length;
    final lng = _validDonors.map((d) => d.longitude!).reduce((a, b) => a + b) /
        _validDonors.length;
    return LatLng(lat, lng);
  }

  Future<void> _callDonor(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  void initState() {
    super.initState();
    debugPrint('🗺️ Total donors received: \${widget.donors.length}');
    for (final d in widget.donors) {
      debugPrint('  → \${d.fullName} | \${d.bloodType} | lat:\${d.latitude} lng:\${d.longitude}');
    }
    debugPrint('✅ Valid donors (have location): \${_validDonors.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Map ──────────────────────────────────────────────
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 12,
                onTap: (_, __) => setState(() => _selectedDonor = null),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.bloodbridge.fci',
                  maxZoom: 19,
                ),
                MarkerLayer(
                  markers: _validDonors.map((donor) {
                    final isSelected = _selectedDonor == donor;
                    return Marker(
                      point: LatLng(donor.latitude!, donor.longitude!),
                      width: isSelected ? 56 : 44,
                      height: isSelected ? 56 : 44,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedDonor = donor);
                          _mapController.move(
                            LatLng(donor.latitude!, donor.longitude!),
                            14,
                          );
                        },
                        child: _DonorMarker(
                          bloodType: donor.bloodType,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // ── Back button ───────────────────────────────────────
            Positioned(
              left: 16,
              top: 16,
              child: _MapIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),

            // ── My location button ────────────────────────────────
            Positioned(
              right: 16,
              top: 16,
              child: _MapIconButton(
                icon: Icons.my_location_rounded,
                onTap: () => _mapController.move(_center, 12),
              ),
            ),

            // ── Donor count badge ────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              top: 16,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.card.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '${_validDonors.length} donors nearby',
                    style: TextStyleHelper.small(context)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            // ── Selected donor bottom card ────────────────────────
            if (_selectedDonor != null)
              Positioned(
                left: 12,
                right: 12,
                bottom: 16,
                child: _DonorBottomCard(
                  donor: _selectedDonor!,
                  onContact: () => _callDonor(_selectedDonor!.phoneNumber),
                  onDismiss: () => setState(() => _selectedDonor = null),
                ),
              ),

            // ── Empty state ───────────────────────────────────────
            if (_validDonors.isEmpty)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_off_outlined,
                          color: AppColors.textMuted, size: 40),
                      const SizedBox(height: 12),
                      Text(
                        'No donors with location data',
                        style: TextStyleHelper.small(context)
                            .copyWith(color: AppColors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Donor Marker
// ─────────────────────────────────────────────
class _DonorMarker extends StatelessWidget {
  final String bloodType;
  final bool isSelected;

  const _DonorMarker({required this.bloodType, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary
            : AppColors.primary.withOpacity(0.85),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: Center(
        child: Text(
          bloodType,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isSelected ? 13 : 11,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom Card (shown on marker tap)
// ─────────────────────────────────────────────
class _DonorBottomCard extends StatelessWidget {
  final NearbyDonor donor;
  final VoidCallback onContact;
  final VoidCallback onDismiss;

  const _DonorBottomCard({
    required this.donor,
    required this.onContact,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              // Blood type circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    donor.bloodType,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donor.fullName.isNotEmpty ? donor.fullName : 'Donor',
                      style: TextStyleHelper.small(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    if (donor.distanceKm > 0)
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 13, color: AppColors.textMuted),
                          const SizedBox(width: 3),
                          Text(
                            '${donor.distanceKm.toStringAsFixed(1)} km away',
                            style: TextStyleHelper.xs(context)
                                .copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: Icon(Icons.close, color: AppColors.textMuted, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onContact,
              icon: const Icon(Icons.phone_outlined,
                  color: Colors.white, size: 18),
              label: Text(
                'Contact Donor',
                style: TextStyleHelper.small(context)
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Map Icon Button
// ─────────────────────────────────────────────
class _MapIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.card.withOpacity(0.95),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
