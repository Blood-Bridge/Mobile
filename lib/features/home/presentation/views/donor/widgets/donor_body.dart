import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/cubit/cubit/donor_cubit.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/widgets/requests_container.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/cubit/receiver_cubit.dart';
import 'package:blood_bridge/features/map/presentation/cubit/map_cubit.dart';
import 'package:blood_bridge/features/map/presentation/view/map_screen.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/widgets/leaderboard_screen.dart';
import 'package:blood_bridge/features/recommendations/presentation/widgets/donation_recommendation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:blood_bridge/core/l10n_ext.dart';

class DonorBody extends StatefulWidget {
  const DonorBody({
    super.key,
    required this.width,
    required this.height,
    required this.cubit,
  });
  final double width;
  final double height;
  final DonorCubit cubit;

  @override
  State<DonorBody> createState() => _DonorBodyState();
}

class _DonorBodyState extends State<DonorBody> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTabRequests();
  }

  void _loadTabRequests() {
    if (_selectedTabIndex == 0) {
      context.read<ReceiverCubit>().loadActiveRequests();
    } else if (_selectedTabIndex == 1) {
      // Deliveries tab: no API call needed — reads from DonorCubit local cache
      setState(() {}); // just rebuild to show local cache
    } else {
      context.read<ReceiverCubit>().loadHistory();
    }
  }

  Widget _buildTabButton(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
          _loadTabRequests();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.popover,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyleHelper.small(context).copyWith(
                color: isSelected ? Colors.white : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DonorCubit, DonorState>(
      listener: (context, state) {
        // ── Accept: switch to Deliveries tab ──────────────────────────────
        if (state is DonorAccepted) {
          showSnackBar(
            'Request Accepted!',
            'You can track it in the Deliveries tab.',
            SnackbarType.success,
          );
          setState(() => _selectedTabIndex = 1);
          try {
            context.read<MapCubit>().refreshMarkers();
          } catch (_) {}
          return;
        }

        // ── Other success actions ─────────────────────────────────────────
        if (state is DonorsSuccess) {
          String title = 'Congratulations!';
          String message = 'Action completed successfully!';

          if (state.donors is Map) {
            final map = state.donors as Map;
            if (map.containsKey('completedRequestId')) {
              message = 'Donation completed successfully!';
            } else if (map.containsKey('cancelledRequestId')) {
              title = 'Success';
              message = 'Donation acceptance cancelled.';
            } else if (map.containsKey('onTheWayRequestId')) {
              title = 'Status Update';
              message = 'You are now marked as on the way!';
            } else if (map.containsKey('arrivedRequestId')) {
              title = 'Status Update';
              message = 'You have successfully marked your arrival!';
            }
          }

          showSnackBar(title, message, SnackbarType.success);

          // Refresh requests
          _loadTabRequests();

          // Refresh map markers
          showSnackBar(title, message, SnackbarType.success);
          setState(() {}); // rebuild to reflect local cache changes
          try {
            context.read<MapCubit>().refreshMarkers();
          } catch (_) {}
        } else if (state is DonorsError) {
          showSnackBar('Error', state.message, SnackbarType.error);
        }
      },
      child: BlocBuilder<ReceiverCubit, ReceiverState>(
        builder: (context, receiverState) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(widget.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DonationRecommendationCard(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        'Nearby Requests',
                        style: TextStyleHelper.h3(context),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            Get.to(() => const LeaderboardScreen()),
                        child: Text(
                          'Leaderboard',
                          style: TextStyleHelper.small(
                            context,
                          ).copyWith(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => Get.to(() => const MapScreen()),
                        child: Text(
                          'Map',
                          style: TextStyleHelper.small(
                            context,
                          ).copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTabButton(0, 'Available'),
                      const SizedBox(width: 8),
                      _buildTabButton(1, 'Deliveries'),
                      const SizedBox(width: 8),
                      _buildTabButton(2, 'Completed'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Deliveries tab: local cache, no API ─────────────────
                  if (_selectedTabIndex == 1) ...[
                    _buildDeliveriesTab(),
                  ]
                  // ── Available & Completed: from ReceiverCubit ───────────
                  else if (receiverState is ReceiverLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (receiverState is ReceiverError)
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Icon(
                            Icons.error_outline,
                            color: AppColors.textMuted,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            receiverState.message,
                            style: TextStyleHelper.small(context),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: context.l10n.retry,
                            height: 44,
                            backgroundColor: AppColors.primary,
                            isEnabled: true,
                            onPressed: () => _loadTabRequests(),
                          ),
                        ],
                      ),
                    )
                  else if (receiverState is ReceiverLoaded) ...[
                    (() {
                      final filtered = receiverState.requests.where((req) {
                        final status = req.status.toLowerCase();
                        if (_selectedTabIndex == 0) {
                          return status == 'open' ||
                              status == 'pending' ||
                              status == 'analyzing';
                        } else {
                          return status == 'completed';
                        }
                      }).toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              _selectedTabIndex == 0
                                  ? 'No active requests nearby'
                                  : 'No completed donations yet',
                              style: TextStyleHelper.small(context),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final req = filtered[index];
                          return RequestsContainer(
                            height: widget.height,
                            width: widget.width,
                            isFirst: index == 0,
                            bloodType: req.bloodTypeDisplay,
                            sitiuation: req.status,
                            address: 'Hospital #${req.hospitalId}',
                            time: req.relativeTime,
                            distance: '--',
                            requestId: req.requestId,
                            donorCubit: widget.cubit,
                            tabIndex: _selectedTabIndex,
                            requestModel: req,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: widget.height * 0.03),
                      );
                    }()),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeliveriesTab() {
    final accepted = widget.cubit.getLocalAccepted();

    if (accepted.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                size: 48,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 12),
              Text(
                'No active deliveries.\nAccept a request to see it here.',
                style: TextStyleHelper.small(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: accepted.length,
      itemBuilder: (context, index) {
        final req = accepted[index];
        return RequestsContainer(
          height: widget.height,
          width: widget.width,
          isFirst: index == 0,
          bloodType: req.bloodTypeDisplay,
          sitiuation: req.status,
          address: 'Hospital #${req.hospitalId}',
          time: req.relativeTime,
          distance: '--',
          requestId: req.requestId,
          donorCubit: widget.cubit,
          tabIndex: 1,
          requestModel: req,
        );
      },
      separatorBuilder: (context, index) =>
          SizedBox(height: widget.height * 0.03),
    );
  }
}
