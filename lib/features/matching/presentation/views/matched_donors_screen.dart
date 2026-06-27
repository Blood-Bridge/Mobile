import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/matching/data/models/match_donor_model.dart';
import 'package:blood_bridge/features/matching/presentation/cubit/match_cubit.dart';
import 'package:blood_bridge/features/matching/presentation/cubit/match_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchedDonorsScreen extends StatefulWidget {
  final int requestId;
  const MatchedDonorsScreen({super.key, required this.requestId});

  @override
  State<MatchedDonorsScreen> createState() => _MatchedDonorsScreenState();
}

class _MatchedDonorsScreenState extends State<MatchedDonorsScreen> {
  bool _sortByScore = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<MatchCubit>().getMatchedDonors(widget.requestId);
  }

  // Make actual phone call
  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      showSnackBar('Error', 'No phone number available', SnackbarType.error);
      return;
    }

    final Uri phoneUri = Uri.parse('tel:$phoneNumber');

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        showSnackBar('Error', 'Could not open phone app', SnackbarType.error);
      }
    } catch (e) {
      showSnackBar('Error', 'Failed to make call', SnackbarType.error);
    }
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
        title: Text('Compatible Donors', style: TextStyleHelper.h1(context)),
      ),
      body: BlocConsumer<MatchCubit, MatchState>(
        listener: (context, state) {
          if (state is MatchError) {
            showSnackBar('Error', state.message, SnackbarType.error);
          }
        },
        builder: (context, state) {
          if (state is MatchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MatchError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Retry'),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 80,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Compatible Donors Found',
                      style: TextStyleHelper.h2(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try again later',
                      style: TextStyleHelper.small(context),
                    ),
                  ],
                ),
              );
            }

            // Sorting
            if (_sortByScore) {
              list.sort((a, b) => b.matchScore.compareTo(a.matchScore));
            } else {
              list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${list.length} potential matches',
                        style: TextStyleHelper.small(context),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _sortByScore = !_sortByScore),
                        child: Row(
                          children: [
                            const Icon(Icons.sort, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              _sortByScore
                                  ? 'Sort by Score'
                                  : 'Sort by Distance',
                              style: TextStyleHelper.small(context).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _loadData(),
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                radius: 28,
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.15,
                                ),
                                child: Text(
                                  '${item.matchScore.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
                                      style: TextStyleHelper.body(
                                        context,
                                      ).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.distanceKm.toStringAsFixed(1)} km away',
                                      style: TextStyleHelper.small(
                                        context,
                                      ).copyWith(color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.green,
                                  size: 28,
                                ),
                                onPressed: () => _makePhoneCall(
                                  item.phonNumber,
                                ), // Real call
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

          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}
