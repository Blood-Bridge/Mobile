import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/hospital_inventory/data/repositories/hospital_repository_mock.dart';
import 'package:blood_bridge/features/hospital_inventory/presentation/cubit/hospital_cubit.dart';
import 'package:blood_bridge/features/hospital_inventory/presentation/cubit/hospital_state.dart';
import 'package:blood_bridge/features/hospital_inventory/presentation/widgets/blood_stock_grid.dart';
import 'package:blood_bridge/features/hospital_inventory/presentation/widgets/donor_tile.dart';
import 'package:blood_bridge/features/hospital_inventory/presentation/widgets/hospital_header.dart';
import 'package:blood_bridge/features/hospital_inventory/presentation/widgets/make_request_button.dart';
import 'package:blood_bridge/features/hospital_inventory/presentation/widgets/proposal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Entry point for the Hospital Inventory dashboard.
///
/// Provides [HospitalCubit] scoped to this screen. Swap
/// `HospitalRepositoryMock()` for `HospitalRepositoryImpl()` once the
/// backend endpoints are ready — no other code needs to change.
class HospitalInventoryView extends StatelessWidget {
  const HospitalInventoryView({super.key, required this.hospitalId});

  final String hospitalId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HospitalCubit(HospitalRepositoryMock())..loadDashboard(hospitalId),
      child: const _HospitalBody(),
    );
  }
}

class _HospitalBody extends StatelessWidget {
  const _HospitalBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocConsumer<HospitalCubit, HospitalState>(
        listener: (context, state) {
          if (state is HospitalRequestSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Request submitted successfully'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HospitalLoading || state is HospitalInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is HospitalError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, style: const TextStyle(color: AppColors.textMuted), textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<HospitalCubit>().loadDashboard('hospital_001'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text('Retry', style: TextStyle(color: AppColors.primaryForeground)),
                    ),
                  ],
                ),
              ),
            );
          }

          final loaded = state is HospitalLoaded
              ? state
              : state is HospitalRequestSubmitted
                  ? HospitalLoaded(hospital: state.hospital)
                  : null;

          if (loaded == null) return const SizedBox.shrink();

          final hospital = loaded.hospital;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      HospitalHeader(
                        name: hospital.name,
                        department: hospital.department,
                        totalUnits: hospital.totalUnits,
                        activeRequestsCount: hospital.activeRequestsCount,
                        criticalTypesCount: hospital.criticalTypesCount,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Blood Stock Overview',
                        style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      BloodStockGrid(items: hospital.stock),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Active Proposals',
                            style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text('View All', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...hospital.proposals.map((p) => ProposalCard(proposal: p, onViewDetails: () {})),
                      const SizedBox(height: 24),
                      const Text(
                        'Nearby Available Donors',
                        style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      ...hospital.nearbyDonors.map((d) => DonorTile(donor: d)),
                    ],
                  ),
                ),
                MakeRequestButton(
                  isSubmitting: loaded.isSubmittingRequest,
                  onSubmit: (bloodType, units) => context.read<HospitalCubit>().submitBloodRequest(
                        bloodType: bloodType,
                        unitsNeeded: units,
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
