import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/cubit/cubit/donor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DonorCubit>().getLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.foreground,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('Top Donors', style: TextStyleHelper.h1(context)),
      ),
      body: BlocBuilder<DonorCubit, DonorState>(
        builder: (context, state) {
          if (state is DonorsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DonorsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(state.message, style: TextStyleHelper.body(context)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<DonorCubit>().getLeaderboard(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          }

          // استخراج القائمة بأمان
          List<dynamic> list = [];

          if (state is DonorsSuccess) {
            final dynamic rawData = state.donors;

            if (rawData is List) {
              list = rawData;
            } else if (rawData is Map<String, dynamic>) {
              list = rawData['items'] as List<dynamic>? ?? [];
            }
          }

          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text('No top donors yet', style: TextStyleHelper.h2(context)),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first champion!',
                    style: TextStyleHelper.bodyMuted(context),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<DonorCubit>().getLeaderboard(),
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final d = list[index] as Map<String, dynamic>? ?? {};

                final name = '${d['firstName'] ?? ''} ${d['lastName'] ?? ''}'
                    .trim();
                final donorName = name.isEmpty ? 'Donor #${index + 1}' : name;
                final bloodType = (d['bloodType'] as String? ?? 'O+')
                    .replaceAll('Positive', '+')
                    .replaceAll('Negative', '−');
                final donationCount = _toInt(
                  d['donationCount'] ?? d['donations'] ?? d['count'] ?? 0,
                );
                final rank = index + 1;

                // Rank Icon
                Widget rankIcon;
                Color rankColor = Colors.transparent;

                if (rank == 1) {
                  rankIcon = const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 28,
                  );
                  rankColor = Colors.amber;
                } else if (rank == 2) {
                  rankIcon = const Icon(
                    Icons.emoji_events,
                    color: Colors.grey,
                    size: 28,
                  );
                  rankColor = Colors.grey;
                } else if (rank == 3) {
                  rankIcon = const Icon(
                    Icons.emoji_events,
                    color: Colors.brown,
                    size: 28,
                  );
                  rankColor = Colors.brown;
                } else {
                  rankIcon = Text(
                    '$rank',
                    style: TextStyleHelper.small(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                  );
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: rank <= 3
                          ? rankColor.withOpacity(0.5)
                          : AppColors.border,
                      width: rank <= 3 ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: rankIcon,
                      ),
                      const SizedBox(width: 16),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          bloodType,
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
                              donorName,
                              style: TextStyleHelper.small(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ranked #$rank',
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
                            '$donationCount',
                            style: TextStyleHelper.h3(
                              context,
                            ).copyWith(color: AppColors.primary),
                          ),
                          Text(
                            'Donations',
                            style: TextStyleHelper.xs(
                              context,
                            ).copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
