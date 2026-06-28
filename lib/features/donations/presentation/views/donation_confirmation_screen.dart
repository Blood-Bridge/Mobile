import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/donations/data/models/donation_model.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_cubit.dart';
import 'package:blood_bridge/features/donations/presentation/cubit/donations_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class DonationConfirmationScreen extends StatelessWidget {
  final DonationModel donation;
  const DonationConfirmationScreen({super.key, required this.donation});

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
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.foreground,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          context.l10n.donationConfirmation,
          style: TextStyleHelper.h2(context),
        ),
      ),
      body: BlocConsumer<DonationsCubit, DonationsState>(
        listener: (context, state) {
          if (state is DonationConfirmSuccess) {
            Get.back();
            Get.snackbar(
              'Success',
              'Donation verified successfully.',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            context.read<DonationsCubit>().fetchDonationById(
              donation.donationProcessId,
            );
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
          final isLoading = state is DonationsLoading;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.02),
                Text(
                  '${context.l10n.donationc} #${donation.donationProcessId}.',
                  style: TextStyleHelper.bodyMuted(context),
                ),
                SizedBox(height: height * 0.04),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildVerifyRow(
                        context,
                        'Donor Confirmation Status',
                        donation.confirmationStatus == 'DonorConfirmed' ||
                            donation.confirmationStatus == 'Confirmed',
                      ),
                      const Divider(color: AppColors.border, height: 24),
                      _buildVerifyRow(
                        context,
                        'Patient/Recipient Status',
                        donation.confirmationStatus == 'PatientConfirmed' ||
                            donation.confirmationStatus == 'Confirmed',
                      ),
                      const Divider(color: AppColors.border, height: 24),
                      _buildVerifyRow(
                        context,
                        'Hospital Final Status',
                        donation.confirmationStatus == 'Confirmed',
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  context.l10n.confirmDonation,
                  style: TextStyleHelper.xs(
                    context,
                  ).copyWith(color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<DonationsCubit>().confirmDonation(
                              donation.donationProcessId,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            context.l10n.confirm,
                            style: TextStyleHelper.h3(
                              context,
                            ).copyWith(color: Colors.white),
                          ),
                  ),
                ),
                SizedBox(height: height * 0.04),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerifyRow(BuildContext context, String label, bool isConfirmed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyleHelper.small(context)),
        Icon(
          isConfirmed ? Icons.check_circle_outline : Icons.pending_outlined,
          color: isConfirmed ? Colors.green : Colors.amber,
          size: 24,
        ),
      ],
    );
  }
}
