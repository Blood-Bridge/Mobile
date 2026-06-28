import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_cubit.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_state.dart';
import 'package:blood_bridge/features/donations/presentation/views/edit_donation_screen.dart';
import 'package:blood_bridge/features/donations/presentation/views/donation_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DonationDetailsScreen extends StatefulWidget {
  final int donationId;
  const DonationDetailsScreen({super.key, required this.donationId});

  @override
  State<DonationDetailsScreen> createState() => _DonationDetailsScreenState();
}

class _DonationDetailsScreenState extends State<DonationDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DonationsCubit>().fetchDonationById(widget.donationId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
        title: Text(context.l10n.donation, style: TextStyleHelper.h1(context)),
        actions: [
          BlocBuilder<DonationsCubit, DonationsState>(
            builder: (context, state) {
              if (state is DonationDetailsLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => Get.to(
                    () => EditDonationScreen(donation: state.donation),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocConsumer<DonationsCubit, DonationsState>(
        listener: (context, state) {
          if (state is DonationDeleteSuccess) {
            Get.back();
            Get.snackbar(
              'Success',
              'Donation deleted successfully',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            context.read<DonationsCubit>().fetchAllDonations();
          } else if (state is DonationsError) {
            Get.snackbar(
              'Error',
              state.message,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
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
                    onPressed: () => context
                        .read<DonationsCubit>()
                        .fetchDonationById(widget.donationId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state is DonationDetailsLoaded) {
            final item = state.donation;
            Color statusColor = Colors.orange;
            if (item.confirmationStatus == 'Confirmed')
              statusColor = Colors.green;
            if (item.confirmationStatus == 'Cancelled')
              statusColor = Colors.red;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n.donationId,
                              style: TextStyleHelper.small(
                                context,
                              ).copyWith(color: AppColors.textMuted),
                            ),
                            Text(
                              '#${item.donationProcessId}',
                              style: TextStyleHelper.small(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(color: AppColors.border, height: 24),
                        _buildDetailRow(
                          context,
                          'Donor ID',
                          '#${item.donorId}',
                        ),
                        _buildDetailRow(
                          context,
                          'Request ID',
                          '#${item.bloodRequestId}',
                        ),
                        _buildDetailRow(
                          context,
                          'Hospital ID',
                          '#${item.hospitalId}',
                        ),
                        _buildDetailRow(
                          context,
                          'Donation Date',
                          item.donationDate
                              .toLocal()
                              .toString()
                              .split(' ')
                              .first,
                        ),
                        const Divider(color: AppColors.border, height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n.status,
                              style: TextStyleHelper.small(
                                context,
                              ).copyWith(color: AppColors.textMuted),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                item.confirmationStatus,
                                style: TextStyleHelper.small(context).copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => Get.to(
                        () => DonationConfirmationScreen(donation: item),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        context.l10n.confirmDonation,
                        style: TextStyleHelper.h3(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () => _confirmDelete(item.donationProcessId),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        context.l10n.deleteDonationRecord,
                        style: TextStyleHelper.h3(
                          context,
                        ).copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(child: Text(context.l10n.noData));
        },
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyleHelper.small(
              context,
            ).copyWith(color: AppColors.textMuted),
          ),
          Text(
            value,
            style: TextStyleHelper.small(context).copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          context.l10n.deleteDonationRecord,
          style: TextStyleHelper.h3(context),
        ),
        content: Text(
          context.l10n.areYouSureYouWantToDeleteThisDonationLogRecord,
          style: TextStyleHelper.small(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              context.l10n.cancel,
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              context.read<DonationsCubit>().deleteDonation(id);
            },
            child: Text(
              context.l10n.delete,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
