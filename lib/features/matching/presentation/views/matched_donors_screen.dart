import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/matching/data/models/match_donor_model.dart';
import 'package:blood_bridge/features/matching/presentation/cubit/match_cubit.dart';
import 'package:blood_bridge/features/matching/presentation/cubit/match_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class MatchedDonorsScreen extends StatefulWidget {
  final int requestId;
  const MatchedDonorsScreen({super.key, required this.requestId});

  @override
  State<MatchedDonorsScreen> createState() => _MatchedDonorsScreenState();
}

class _MatchedDonorsScreenState extends State<MatchedDonorsScreen> {
  bool _sortByScore = true; // true = score, false = distance

  @override
  void initState() {
    super.initState();
    context.read<MatchCubit>().getMatchedDonors(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.foreground, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text('Compatible Donors', style: TextStyleHelper.h1(context)),
      ),
      body: BlocBuilder<MatchCubit, MatchState>(
        builder: (context, state) {
          if (state is MatchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MatchError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 54, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyleHelper.body(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.read<MatchCubit>().getMatchedDonors(widget.requestId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Retry', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is MatchSuccess) {
            List<MatchDonorModel> list = List.from(state.matchedDonors);

            if (list.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 72, color: AppColors.textMuted),
                      const SizedBox(height: 20),
                      Text(
                        'No Compatible Donors Found',
                        style: TextStyleHelper.h2(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We couldn\'t find any compatible donors in your area at the moment. Try updating the urgency level or checking back shortly.',
                        style: TextStyleHelper.small(context).copyWith(color: AppColors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            // Perform sorting
            if (_sortByScore) {
              list.sort((a, b) => b.matchScore.compareTo(a.matchScore));
            } else {
              list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${list.length} potential matches found',
                        style: TextStyleHelper.small(context).copyWith(color: AppColors.textMuted),
                      ),
                      Row(
                        children: [
                          Icon(Icons.sort, size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _sortByScore = !_sortByScore;
                              });
                            },
                            child: Text(
                              _sortByScore ? 'Sort by Match Score' : 'Sort by Distance',
                              style: TextStyleHelper.xs(context).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => context.read<MatchCubit>().getMatchedDonors(widget.requestId),
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primary.withOpacity(0.1),
                                child: Text(
                                  '${item.matchScore}%',
                                  style: TextStyleHelper.small(context).copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyleHelper.body(context).copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, size: 14, color: AppColors.textMuted),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${item.distanceKm.toStringAsFixed(1)} km away',
                                          style: TextStyleHelper.xs(context).copyWith(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.phone, color: AppColors.primary),
                                  onPressed: () {
                                    // Contact action
                                    Get.snackbar(
                                      'Contact Initiated',
                                      'Sending donation request notification to ${item.name}...',
                                      backgroundColor: AppColors.card,
                                      colorText: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
