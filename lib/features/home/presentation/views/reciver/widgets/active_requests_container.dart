import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActiveRequestsContainer extends StatelessWidget {
  const ActiveRequestsContainer({
    super.key,
    required this.height,
    required this.width,
    required this.isConfirmed,
    required this.situation,
    required this.bloodType,
    required this.donorsNumber,
    required this.time,
    required this.distance,
  });

  final double height;
  final double width;
  final bool isConfirmed;
  final String situation;
  final String bloodType;
  final int donorsNumber;
  final String time;
  final String distance;

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
          color: isConfirmed ? AppColors.likeprimary : AppColors.border,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
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
                height: height * 0.08,
                width: height * 0.08,
              ),
              SizedBox(width: width * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 1,
                      bottom: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      situation,
                      style: TextStyleHelper.xs(
                        context,
                      ).copyWith(color: AppColors.primary),
                    ),
                  ),
                  Center(
                    child: Text(
                      '$donorsNumber Donors responded',
                      style: TextStyleHelper.small(context),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Icon(Icons.access_time, color: AppColors.textMuted, size: 16),
                  Text('$time ago', style: TextStyleHelper.xs(context)),
                ],
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          isConfirmed
              ? Container(
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: AppColors.popover,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                        ),
                        SizedBox(width: width * 0.02),
                        Text(
                          'Donor Confirmed. $distance',
                          style: TextStyleHelper.small(
                            context,
                          ).copyWith(color: AppColors.primaryForeground),
                        ),
                      ],
                    ),
                  ),
                )
              : LinearProgressIndicator(
                  value: .5,
                  backgroundColor: AppColors.border,
                  borderRadius: BorderRadius.circular(65484200),
                  color: AppColors.primary,
                ),
          SizedBox(height: height * 0.02),
          isConfirmed
              ? Row(
                  children: [
                    Container(
                      width: width * .6,
                      height: height * .07,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone),
                            SizedBox(width: width * 0.03),
                            Text(
                              'Contact Donor',
                              style: TextStyleHelper.small(
                                context,
                              ).copyWith(color: AppColors.foreground),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: width * .02),
                    Container(
                      width: height * .07,
                      height: height * .07,
                      decoration: BoxDecoration(
                        color: AppColors.popover,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border, width: 2),
                      ),
                      child: Icon(Icons.location_on_outlined),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: width * .4,
                      height: height * .07,
                      decoration: BoxDecoration(
                        color: AppColors.popover,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined),
                            SizedBox(width: width * .02),
                            Text(
                              'View map',
                              style: TextStyleHelper.small(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: width * .02),
                    Container(
                      width: width * .4,
                      height: height * .07,
                      decoration: BoxDecoration(
                        color: AppColors.popover,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyleHelper.small(context),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
