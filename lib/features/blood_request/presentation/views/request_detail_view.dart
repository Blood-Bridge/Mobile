import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/blood_request/data/repositories/blood_request_repository_mock.dart';
import 'package:blood_bridge/features/blood_request/presentation/cubit/request_detail_cubit.dart';
import 'package:blood_bridge/features/blood_request/presentation/cubit/request_detail_state.dart';
import 'package:blood_bridge/features/blood_request/presentation/widgets/expiry_countdown.dart';
import 'package:blood_bridge/features/blood_request/presentation/widgets/request_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Full-screen view for a single blood request, where the donor can
/// review details and accept/decline within a countdown window.
///
/// Provides [RequestDetailCubit] scoped to this screen. Swap
/// `BloodRequestRepositoryMock()` for `BloodRequestRepositoryImpl()`
/// once the backend endpoints are ready — no other code needs to change.
class RequestDetailView extends StatelessWidget {
  const RequestDetailView({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestDetailCubit(BloodRequestRepositoryMock())..loadRequest(requestId),
      child: const _RequestDetailBody(),
    );
  }
}

class _RequestDetailBody extends StatelessWidget {
  const _RequestDetailBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: BlocConsumer<RequestDetailCubit, RequestDetailState>(
        listener: (context, state) {
          if (state is RequestDetailResponded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.accepted ? 'Request accepted' : 'Request declined'),
                backgroundColor: state.accepted ? AppColors.success : AppColors.muted,
              ),
            );
            Navigator.maybePop(context);
          }
        },
        builder: (context, state) {
          if (state is RequestDetailLoading || state is RequestDetailInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is RequestDetailError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: AppColors.textMuted)),
            );
          }

          final loaded = state as RequestDetailLoaded;
          final request = loaded.request;
          final isDisabled = loaded.isResponding || loaded.isExpired;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.destructive.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.destructive),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bolt, size: 14, color: AppColors.destructive),
                            SizedBox(width: 4),
                            Text(
                              'Emergency Request',
                              style: TextStyle(color: AppColors.destructive, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                            child: const Icon(Icons.bloodtype, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${request.bloodType} Blood Needed',
                                  style: const TextStyle(color: AppColors.text, fontSize: 17, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${request.ward} • ${request.hospitalName}',
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _InfoRow(
                        icon: Icons.place_outlined,
                        label: '${request.distanceKm.toStringAsFixed(1)} km away',
                        trailing: Row(
                          children: const [
                            Icon(Icons.directions, size: 14, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text('Directions', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        icon: Icons.access_time,
                        label: 'Requested',
                        trailing: const Text('2 minutes ago', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ),
                      const SizedBox(height: 16),
                      RequestDetailsCard(request: request),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0B84A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0B84A).withOpacity(0.4)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.warning_amber_rounded, color: Color(0xFFE0B84A), size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Important',
                                    style: TextStyle(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Please ensure you\'re eligible to donate and have eaten properly '
                                    'before arriving. You\'ll be contacted by hospital staff after accepting.',
                                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isDisabled ? null : () => context.read<RequestDetailCubit>().accept(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor: AppColors.likeprimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: loaded.isResponding
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryForeground),
                                )
                              : const Text(
                                  'Accept & Respond',
                                  style: TextStyle(color: AppColors.primaryForeground, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton(
                          onPressed: isDisabled ? null : () => context.read<RequestDetailCubit>().decline(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Decline', style: TextStyle(color: AppColors.textMuted)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ExpiryCountdown(remaining: loaded.remaining),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.trailing});

  final IconData icon;
  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        const Spacer(),
        trailing,
      ],
    );
  }
}
