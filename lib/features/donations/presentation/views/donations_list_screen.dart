import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_cubit.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_state.dart';
import 'package:blood_bridge/features/donations/presentation/views/create_donation_screen.dart';
import 'package:blood_bridge/features/donations/presentation/views/donation_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DonationsListScreen extends StatefulWidget {
  const DonationsListScreen({super.key});

  @override
  State<DonationsListScreen> createState() => _DonationsListScreenState();
}

class _DonationsListScreenState extends State<DonationsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DonationsCubit>().fetchAllDonations();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.foreground, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text('My Donations', style: TextStyleHelper.h1(context)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreateDonationScreen()),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<DonationsCubit, DonationsState>(
        builder: (context, state) {
          if (state is DonationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DonationsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(state.message, style: TextStyleHelper.body(context)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DonationsCubit>().fetchAllDonations(),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is DonationsLoaded) {
            final list = state.donations;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text('No donation history found.', style: TextStyleHelper.bodyMuted(context)),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<DonationsCubit>().fetchAllDonations(),
              color: AppColors.primary,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  final isConfirmed = item.confirmationStatus == 'Confirmed';
                  final isPending = item.confirmationStatus == 'Pending';

                  Color statusColor = Colors.orange;
                  if (isConfirmed) statusColor = Colors.green;
                  if (item.confirmationStatus == 'Cancelled') statusColor = Colors.red;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onTap: () => Get.to(() => DonationDetailsScreen(donationId: item.donationProcessId)),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: Icon(Icons.favorite, color: AppColors.primary, size: 20),
                      ),
                      title: Text(
                        'Donation #${item.donationProcessId}',
                        style: TextStyleHelper.small(context).copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${item.donationDate.toLocal().toString().split(' ').first}',
                            style: TextStyleHelper.xs(context).copyWith(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              item.confirmationStatus,
                              style: TextStyleHelper.xs(context).copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right, color: AppColors.textMuted),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Pull to refresh'));
        },
      ),
    );
  }
}
