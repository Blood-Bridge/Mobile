import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/hospital_dashboard/presentation/cubit/hospital_dashboard_cubit.dart';
import 'package:blood_bridge/features/hospital_profile/presentation/cubit/hospital_profile_cubit.dart';
import 'package:blood_bridge/features/hospital_profile/presentation/views/hospital_profile_screen.dart';
import 'package:blood_bridge/features/map/presentation/view/map_screen.dart';
import 'package:blood_bridge/features/setting/presentation/views/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalDashboardScreen extends StatelessWidget {
  const HospitalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HospitalDashboardCubit()..fetchAll(),
      child: const _HospitalDashboardBody(),
    );
  }
}

class _HospitalDashboardBody extends StatelessWidget {
  const _HospitalDashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HospitalDashboardCubit, HospitalDashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.bg,
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.error != null
              ? _ErrorView(
                  message: state.error!,
                  onRetry: () =>
                      context.read<HospitalDashboardCubit>().fetchAll(),
                )
              : _DashboardContent(state: state),
          bottomNavigationBar: _CreateRequestButton(),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Error View
// ─────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.primary, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyleHelper.small(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Dashboard Content
// ─────────────────────────────────────────────
// ─────────────────────────────────────────────
// Dashboard Content
// ─────────────────────────────────────────────
class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.state});
  final HospitalDashboardState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HospitalDashboardCubit>();

    return RefreshIndicator(
      onRefresh: () async {
        await cubit.fetchAll();
      },
      color: AppColors.primary,
      backgroundColor: AppColors.card,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // مهم جداً
        slivers: [
          _HospitalAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _SummaryRow(state: state),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Blood Stock Overview'),
                  const SizedBox(height: 12),
                  _BloodStockGrid(inventory: state.bloodInventory),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Active Requests',
                    action: 'View All',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  _ActiveRequestsList(requests: state.activeRequests),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Nearby Available Donors',
                    action: 'Map View',
                    onAction: () {
                      final donors = context
                          .read<HospitalDashboardCubit>()
                          .state
                          .nearbyDonors;
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => MapScreen()));
                    },
                  ),
                  const SizedBox(height: 12),
                  _NearbyDonorsList(donors: state.nearbyDonors),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// App Bar
// ─────────────────────────────────────────────
class _HospitalAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.bg,
      floating: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('City Hospital', style: TextStyleHelper.h1(context)),
          Text(
            'Blood Management',
            style: TextStyleHelper.xs(
              context,
            ).copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.person_outline, color: AppColors.textMuted),
          onPressed: () {
            context.read<HospitalProfileCubit>().fetchProfile();
            Get.to(() => const HospitalProfileScreen());
          },
        ),
        IconButton(
          icon: Icon(Icons.settings_outlined, color: AppColors.textMuted),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SettingView(isHospital: true),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Summary Row (3 cards)
// ─────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.state});
  final HospitalDashboardState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Total Stock',
            value: '${state.availableBloodUnits} units',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            label: 'Active Requests',
            value: state.pendingRequests.toString(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            label: 'Available Donors',
            value: state.activeDonors.toString(),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyleHelper.xs(
              context,
            ).copyWith(color: AppColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyleHelper.h3(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyleHelper.h3(context)),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: TextStyleHelper.small(
                context,
              ).copyWith(color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Blood Stock Grid
// ─────────────────────────────────────────────
class _BloodStockGrid extends StatelessWidget {
  const _BloodStockGrid({required this.inventory});
  final List<BloodInventoryItem> inventory;

  @override
  Widget build(BuildContext context) {
    if (inventory.isEmpty) {
      return _emptyPlaceholder(context, 'No inventory data');
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: inventory.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, i) => _BloodStockCard(item: inventory[i]),
    );
  }
}

class _BloodStockCard extends StatelessWidget {
  const _BloodStockCard({required this.item});
  final BloodInventoryItem item;

  Color get _statusColor {
    if (item.status == 'Critical') return const Color(0xFFE53935);
    if (item.status == 'Low Stock') return const Color(0xFFFF8F00);
    return AppColors.success;
  }

  Color get _borderColor {
    if (item.status == 'Critical')
      return const Color(0xFFE53935).withOpacity(0.4);
    if (item.status == 'Low Stock')
      return const Color(0xFFFF8F00).withOpacity(0.4);
    return AppColors.border;
  }

  IconData get _trendIcon {
    if (item.trend == 'up') return Icons.trending_up_rounded;
    if (item.trend == 'down') return Icons.trending_down_rounded;
    return Icons.trending_flat_rounded;
  }

  Color get _trendColor {
    if (item.trend == 'up') return AppColors.success;
    if (item.trend == 'down') return const Color(0xFFE53935);
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.water_drop,
                    color: item.status == 'Critical'
                        ? const Color(0xFFE53935)
                        : item.status == 'Low Stock'
                        ? const Color(0xFFFF8F00)
                        : AppColors.textMuted,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.label,
                    style: TextStyleHelper.small(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(_trendIcon, color: _trendColor, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${item.units}',
            style: TextStyleHelper.h1(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'units available',
            style: TextStyleHelper.xs(
              context,
            ).copyWith(color: AppColors.textMuted),
          ),
          if (item.status != null && item.status != 'Normal') ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.status!,
                style: TextStyleHelper.xs(
                  context,
                ).copyWith(color: _statusColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Active Requests List
// ─────────────────────────────────────────────
class _ActiveRequestsList extends StatelessWidget {
  const _ActiveRequestsList({required this.requests});
  final List<ActiveRequest> requests;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return _emptyPlaceholder(context, 'No active requests');
    }
    return Column(
      children: requests
          .map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ActiveRequestCard(request: r),
            ),
          )
          .toList(),
    );
  }
}

class _ActiveRequestCard extends StatelessWidget {
  const _ActiveRequestCard({required this.request});
  final ActiveRequest request;

  Color get _urgencyColor {
    switch (request.urgency.toLowerCase()) {
      case 'critical':
        return const Color(0xFFE53935);
      case 'urgent':
        return const Color(0xFFFF8F00);
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _urgencyColor.withOpacity(0.4), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                // Blood type badge
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _urgencyColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      request.bloodType,
                      style: TextStyleHelper.xs(context).copyWith(
                        color: _urgencyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _urgencyColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          request.urgency,
                          style: TextStyleHelper.xs(context).copyWith(
                            color: _urgencyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.timeAgo,
                        style: TextStyleHelper.xs(
                          context,
                        ).copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${request.donorCount}',
                      style: TextStyleHelper.h3(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'donors',
                      style: TextStyleHelper.xs(
                        context,
                      ).copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  'View Details',
                  style: TextStyleHelper.small(context),
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
// Nearby Donors List
// ─────────────────────────────────────────────
class _NearbyDonorsList extends StatelessWidget {
  const _NearbyDonorsList({required this.donors});
  final List<NearbyDonor> donors;

  @override
  Widget build(BuildContext context) {
    if (donors.isEmpty) {
      return _emptyPlaceholder(context, 'No nearby donors');
    }
    return Column(
      children: donors
          .map(
            (d) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DonorTile(donor: d),
            ),
          )
          .toList(),
    );
  }
}

class _DonorTile extends StatelessWidget {
  const _DonorTile({required this.donor});
  final NearbyDonor donor;

  Future<void> _callDonor() async {
    final uri = Uri(scheme: 'tel', path: donor.phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Blood type circle
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                donor.bloodType,
                style: TextStyleHelper.small(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
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
                  style: TextStyleHelper.small(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  donor.distanceKm > 0
                      ? '${donor.distanceKm.toStringAsFixed(1)} km away'
                      : donor.phoneNumber,
                  style: TextStyleHelper.xs(
                    context,
                  ).copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _callDonor,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 0,
            ),
            child: Text(
              'Contact',
              style: TextStyleHelper.small(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Create Request Button
// ─────────────────────────────────────────────
class _CreateRequestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            label: Text(
              'Create New Request',
              style: TextStyleHelper.small(
                context,
              ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Helper
// ─────────────────────────────────────────────
Widget _emptyPlaceholder(BuildContext context, String text) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Text(
      text,
      style: TextStyleHelper.small(
        context,
      ).copyWith(color: AppColors.textMuted),
      textAlign: TextAlign.center,
    ),
  );
}
