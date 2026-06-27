import 'package:blood_bridge/core/models/blood_request_model.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/cubit/cubit/donor_cubit.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/cubit/receiver_cubit.dart';
import 'package:blood_bridge/features/map/presentation/cubit/map_cubit.dart';
import 'package:blood_bridge/features/map/presentation/view/map_screen.dart';
import 'package:blood_bridge/features/request_status/presentation/views/request_status_screen.dart';
import 'package:blood_bridge/features/request_status/presentation/cubit/request_status_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestsContainer extends StatelessWidget {
  const RequestsContainer({
    super.key,
    required this.height,
    required this.width,
    required this.isFirst,
    required this.sitiuation,
    required this.bloodType,
    required this.address,
    required this.time,
    required this.distance,
    required this.requestId,
    required this.donorCubit,
    this.tabIndex = 0,
    this.requestModel, // ← new optional param for local caching
  });

  final double height;
  final double width;
  final bool isFirst;
  final String sitiuation;
  final String bloodType;
  final String address;
  final String time;
  final String distance;
  final int requestId;
  final DonorCubit donorCubit;
  final int tabIndex;
  final BloodRequestModel? requestModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: height * 0.27),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFirst ? AppColors.likeprimary : AppColors.border,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/container.png",
                height: height * 0.08,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: height * 0.08,
                    width: height * 0.08,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        bloodType,
                        style: TextStyleHelper.h2(
                          context,
                        ).copyWith(color: AppColors.primary),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(bloodType, style: TextStyleHelper.h2(context)),
                        SizedBox(width: width * 0.03),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            sitiuation,
                            style: TextStyleHelper.xs(
                              context,
                            ).copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    Text(address, style: TextStyleHelper.small(context)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.textMuted,
                size: 18,
              ),
              Text('$distance ', style: TextStyleHelper.xs(context)),
              SizedBox(width: width * 0.03),
              Icon(CupertinoIcons.clock, color: AppColors.textMuted, size: 18),
              Text('$time ago', style: TextStyleHelper.xs(context)),
            ],
          ),
          SizedBox(height: height * 0.015),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (tabIndex == 0) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Accept',
                  height: height * 0.06,
                  backgroundColor: AppColors.primary,
                  isEnabled: true,
                  onPressed: () {
                    // Pass requestModel so DonorCubit can cache it locally
                    donorCubit.acceptRequest(
                      requestId,
                      requestModel: requestModel,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  text: 'Decline',
                  height: height * 0.06,
                  backgroundColor: AppColors.popover,
                  isEnabled: true,
                  onPressed: () {
                    donorCubit.rejectRequest(requestId);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomButton(
            text: 'View Details',
            height: height * 0.06,
            isEnabled: true,
            backgroundColor: AppColors.popover.withOpacity(0.5),
            onPressed: () => _showDetailsDialog(context),
          ),
        ],
      );
    } else if (tabIndex == 1) {
      final situationLower = sitiuation
          .toLowerCase()
          .replaceAll('_', '')
          .replaceAll(' ', '');
      String mainButtonText = 'Complete Donation';
      Color mainButtonColor = Colors.green;
      VoidCallback mainAction = () => donorCubit.completeDonation(requestId);

      if (situationLower == 'accepted') {
        mainButtonText = 'Mark On The Way';
        mainButtonColor = AppColors.primary;
        mainAction = () => donorCubit.markOnTheWay(requestId);
      } else if (situationLower == 'ontheway') {
        mainButtonText = 'Mark Arrived';
        mainButtonColor = const Color(0xFF27AE60);
        mainAction = () => donorCubit.markArrived(requestId);
      }

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: mainButtonText,
                  height: height * 0.06,
                  backgroundColor: mainButtonColor,
                  isEnabled: true,
                  onPressed: mainAction,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => Get.to(() => const MapScreen()),
                child: Container(
                  height: height * 0.06,
                  width: height * 0.06,
                  decoration: BoxDecoration(
                    color: AppColors.popover,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 2),
                  ),
                  child: const Icon(Icons.map, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Cancel Acceptance',
                  height: height * 0.06,
                  backgroundColor: Colors.red.withOpacity(0.2),
                  isEnabled: true,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: AppColors.card,
                          title: Text(
                            'Cancel Acceptance',
                            style: TextStyleHelper.h3(context),
                          ),
                          content: Text(
                            'Are you sure you want to cancel your donation acceptance for this request?',
                            style: TextStyleHelper.small(context),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'No',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                donorCubit.cancelAcceptance(requestId);
                              },
                              child: const Text(
                                'Yes, Cancel',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  text: 'View Status',
                  height: height * 0.06,
                  backgroundColor: AppColors.popover.withOpacity(0.5),
                  isEnabled: true,
                  onPressed: () {
                    final statusCubit = RequestStatusCubit()
                      ..getRequestStatus(requestId);
                    Get.to(
                      () => BlocProvider.value(
                        value: statusCubit,
                        child: RequestStatusScreen(requestId: requestId),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(
              'Donation Completed',
              style: TextStyleHelper.small(
                context,
              ).copyWith(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: Text('Request Details', style: TextStyleHelper.h3(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context, 'Request ID', '#$requestId'),
              const Divider(color: AppColors.border),
              _buildDetailRow(
                context,
                'Urgency',
                sitiuation,
                isUrgent: sitiuation == 'Critical' || sitiuation == 'Urgent',
              ),
              const Divider(color: AppColors.border),
              _buildDetailRow(context, 'Blood Type', bloodType),
              const Divider(color: AppColors.border),
              _buildDetailRow(context, 'Hospital/Location', address),
              const Divider(color: AppColors.border),
              _buildDetailRow(context, 'Distance', distance),
              const Divider(color: AppColors.border),
              _buildDetailRow(context, 'Created', time),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isUrgent = false,
  }) {
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
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyleHelper.small(context).copyWith(
                color: isUrgent ? AppColors.primary : Colors.white,
                fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
