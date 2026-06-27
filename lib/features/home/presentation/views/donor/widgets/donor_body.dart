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
  // 0 = Available, 1 = Deliveries (accepted), 2 = Completed
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTabRequests();
  }

  void _loadTabRequests() {
    if (_selectedTabIndex == 0) {
      // Available requests come from ReceiverCubit (all active requests)
      context.read<ReceiverCubit>().loadActiveRequests();
    } else if (_selectedTabIndex == 1) {
      // Deliveries: requests THIS donor has accepted — use DonorCubit
      context.read<DonorCubit>().getAcceptedRequests();
    } else {
      // Completed: from history filtered by status
      context.read<ReceiverCubit>().loadHistory(status: 'Completed');
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
        // ── Accept success → switch to Deliveries tab and load it ──
        if (state is DonorAccepted) {
          showSnackBar(
            'Request Accepted!',
            'You have accepted blood request #${state.requestId}. '
                'Track it in the Deliveries tab.',
            SnackbarType.success,
          );
          setState(() {
            _selectedTabIndex = 1;
          });
          context.read<DonorCubit>().getAcceptedRequests();
          // Refresh map markers
          try {
            context.read<MapCubit>().refreshMarkers();
          } catch (_) {}
          return;
        }

        // ── Other DonorCubit success messages ──
        if (state is DonorsSuccess) {
          String title = 'Success!';
          String message = 'Action completed successfully!';

          if (state.donors is Map) {
            final map = state.donors as Map;
            if (map.containsKey('completedRequestId')) {
              title = 'Donation Completed 🎉';
              message =
                  'Thank you! Your donation has been marked as completed.';
            } else if (map.containsKey('cancelledRequestId')) {
              title = 'Acceptance Cancelled';
              message = 'Your donation acceptance has been cancelled.';
            } else if (map.containsKey('onTheWayRequestId')) {
              title = 'Status Updated';
              message = 'You are now marked as on the way!';
            } else if (map.containsKey('arrivedRequestId')) {
              title = 'Arrived!';
              message =
                  'You have successfully marked your arrival at the hospital.';
            }
          }

          showSnackBar(title, message, SnackbarType.success);

          // Refresh the current tab
          _loadTabRequests();

          // Refresh map markers
          try {
            context.read<MapCubit>().refreshMarkers();
          } catch (_) {}
        } else if (state is DonorsError) {
          showSnackBar('Error', state.message, SnackbarType.error);
        } else if (state is DonorAcceptedRequestsError) {
          showSnackBar('Error', state.message, SnackbarType.error);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(widget.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DonationRecommendationCard(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text('Nearby Requests', style: TextStyleHelper.h3(context)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Get.to(() => const LeaderboardScreen()),
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

              // ── Tab 0 & 2: driven by ReceiverCubit ──────────────────────
              if (_selectedTabIndex == 0 || _selectedTabIndex == 2)
                BlocBuilder<ReceiverCubit, ReceiverState>(
                  builder: (context, state) {
                    if (state is ReceiverLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is ReceiverError) {
                      return _buildErrorView(state.message);
                    }
                    if (state is ReceiverLoaded) {
                      final filtered = state.requests.where((req) {
                        final status = req.status.toLowerCase();
                        if (_selectedTabIndex == 0) {
                          return status == 'open' ||
                              status == 'pending' ||
                              status == 'analyzing';
                        } else {
                          return status == 'completed';
                        }
                      }).toList();

                      return _buildRequestList(
                        filtered,
                        _selectedTabIndex == 0
                            ? 'No active requests nearby'
                            : 'No completed donations yet',
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

              // ── Tab 1: Deliveries — driven by DonorCubit ────────────────
              if (_selectedTabIndex == 1)
                BlocBuilder<DonorCubit, DonorState>(
                  builder: (context, state) {
                    if (state is DonorAcceptedRequestsLoading ||
                        state is DonorsLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is DonorAcceptedRequestsError) {
                      return _buildErrorView(state.message);
                    }
                    if (state is DonorAcceptedRequestsLoaded) {
                      return _buildRequestList(
                        state.requests,
                        'No active deliveries.\nAccept a request to see it here.',
                      );
                    }
                    // While other DonorCubit actions are in progress show spinner
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestList(List<dynamic> filtered, String emptyMessage) {
    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                _selectedTabIndex == 1
                    ? Icons.local_shipping_outlined
                    : Icons.inbox_outlined,
                size: 48,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 12),
              Text(
                emptyMessage,
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
        );
      },
      separatorBuilder: (context, index) =>
          SizedBox(height: widget.height * 0.03),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 24),
          Icon(Icons.error_outline, color: AppColors.textMuted, size: 40),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyleHelper.small(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Retry',
            height: 44,
            backgroundColor: AppColors.primary,
            isEnabled: true,
            onPressed: () => _loadTabRequests(),
          ),
        ],
      ),
    );
  }
}
