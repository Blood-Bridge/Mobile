import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/cubit/receiver_cubit.dart';
import 'package:blood_bridge/features/matching/presentation/views/matched_donors_screen.dart';
import 'package:blood_bridge/features/request_status/presentation/views/request_status_screen.dart';
import 'package:blood_bridge/features/map/presentation/view/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveRequestsContainer extends StatefulWidget {
  const ActiveRequestsContainer({
    super.key,
    required this.height,
    required this.width,
    required this.isConfirmed,
    required this.situation,
    required this.bloodType,
    required this.time,
    required this.distance,
    required this.requestId,
  });

  final double height;
  final double width;
  final bool isConfirmed;
  final String situation;
  final String bloodType;
  final String time;
  final String distance;
  final int requestId;

  @override
  State<ActiveRequestsContainer> createState() =>
      _ActiveRequestsContainerState();
}

class _ActiveRequestsContainerState extends State<ActiveRequestsContainer> {
  @override
  void initState() {
    super.initState();

    if (widget.situation == 'Accepted' || widget.situation == 'Completed') {
      context.read<ReceiverCubit>().fetchAcceptedDonor(widget.requestId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiverCubit, ReceiverState>(
      builder: (context, state) {
        final cubit = context.read<ReceiverCubit>();

        final donor = cubit.acceptedDonors[widget.requestId];

        final int matchesCount = cubit.getMatchesCount(widget.requestId);

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: widget.height * 0.27),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.situation == 'Cancelled'
                  ? Colors.red
                  : widget.situation == 'Accepted' ||
                        widget.situation == 'Completed'
                  ? AppColors.likeprimary
                  : AppColors.border,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: widget.height * 0.08,
                    width: widget.height * 0.08,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.bloodType,
                        style: TextStyleHelper.h2(
                          context,
                        ).copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),

                  SizedBox(width: widget.width * 0.03),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(
                          () =>
                              RequestStatusScreen(requestId: widget.requestId),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: widget.situation == 'Cancelled'
                                ? Colors.red.withOpacity(0.1)
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.situation,
                                style: TextStyleHelper.xs(context).copyWith(
                                  color: widget.situation == 'Cancelled'
                                      ? Colors.red
                                      : AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, size: 10),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      GestureDetector(
                        onTap: () => Get.to(
                          () =>
                              MatchedDonorsScreen(requestId: widget.requestId),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.people,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$matchesCount Matches found',
                              style: TextStyleHelper.small(context).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.time} ago',
                        style: TextStyleHelper.xs(context),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ACCEPTED
              if (widget.situation == 'Accepted' ||
                  widget.situation == 'Completed') ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.popover,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Donor Confirmed',
                            style: TextStyleHelper.small(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      if (donor != null) ...[
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),

                        Text(
                          'Name: ${donor['firstName']} ${donor['lastName']}',
                        ),

                        Text('Blood Type: ${donor['bloodType']}'),

                        Text('Phone: ${donor['phoneNumber']}'),
                      ] else
                        const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (donor != null) {
                            final url = Uri.parse(
                              'tel:${donor['phoneNumber']}',
                            );
                            await launchUrl(url);
                          }
                        },
                        child: Container(
                          height: widget.height * 0.07,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Contact Donor',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    InkWell(
                      onTap: () {
                        if (donor != null &&
                            donor['latitude'] != null &&
                            donor['longitude'] != null) {
                          Get.to(
                            () => MapScreen(
                              donorLocation: LatLng(
                                (donor['latitude'] as num).toDouble(),
                                (donor['longitude'] as num).toDouble(),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: widget.height * 0.07,
                        height: widget.height * 0.07,
                        decoration: BoxDecoration(
                          color: AppColors.popover,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border, width: 2),
                        ),
                        child: const Icon(Icons.location_on_outlined),
                      ),
                    ),
                  ],
                ),
              ]
              /// CANCELLED
              else if (widget.situation == 'Cancelled') ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        'This request was cancelled',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
              /// PENDING
              else ...[
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: AppColors.border,
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.to(() => const MapScreen()),
                        child: Container(
                          height: widget.height * 0.07,
                          decoration: BoxDecoration(
                            color: AppColors.popover,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.border,
                              width: 2,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined),
                              SizedBox(width: 8),
                              Text('View on Map'),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: InkWell(
                        onTap: () {
                          context.read<ReceiverCubit>().cancelRequest(
                            widget.requestId,
                          );
                        },
                        child: Container(
                          height: widget.height * 0.07,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              'Cancel Request',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
