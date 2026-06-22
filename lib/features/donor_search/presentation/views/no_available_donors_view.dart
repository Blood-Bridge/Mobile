import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/donor_search/data/repositories/donor_search_repository_mock.dart';
import 'package:blood_bridge/features/donor_search/presentation/cubit/donor_search_cubit.dart';
import 'package:blood_bridge/features/donor_search/presentation/cubit/donor_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shown when a donor search returns no matches nearby. Lets the
/// user expand the search radius via [DonorSearchCubit].
///
/// Provides [DonorSearchCubit] scoped to this screen. Swap
/// `DonorSearchRepositoryMock()` for `DonorSearchRepositoryImpl()`
/// once the backend endpoints are ready — no other code needs to change.
class NoAvailableDonorsView extends StatelessWidget {
  const NoAvailableDonorsView({super.key, required this.bloodType});

  final String bloodType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DonorSearchCubit(DonorSearchRepositoryMock())..search(bloodType),
      child: const _NoAvailableDonorsBody(),
    );
  }
}

class _NoAvailableDonorsBody extends StatelessWidget {
  const _NoAvailableDonorsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocConsumer<DonorSearchCubit, DonorSearchState>(
        listener: (context, state) {
          if (state is DonorSearchFound) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.result.donorsFound} donors found nearby'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DonorSearchLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is DonorSearchError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: AppColors.textMuted)),
            );
          }

          if (state is DonorSearchFound) {
            return Center(
              child: Text(
                '${state.result.donorsFound} donors found within ${state.result.searchRadiusKm.toStringAsFixed(0)} km',
                style: const TextStyle(color: AppColors.text),
                textAlign: TextAlign.center,
              ),
            );
          }

          final empty = state as DonorSearchEmpty;

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                        child: const Icon(Icons.people_outline, size: 28, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Available Donors',
                        style: TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'There are no donors matching your blood type nearby at the moment.',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: empty.isExpanding
                              ? null
                              : () => context.read<DonorSearchCubit>().expandSearchArea(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor: AppColors.likeprimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: empty.isExpanding
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryForeground),
                                )
                              : const Text(
                                  'Expand Search Area',
                                  style: TextStyle(color: AppColors.primaryForeground, fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
