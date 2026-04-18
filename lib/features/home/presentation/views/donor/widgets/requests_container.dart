import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  });

  final double height;
  final double width;
  final bool isFirst;
  final String sitiuation;
  final String bloodType;
  final String address;
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
                  debugPrint("Image error: $error");
                  return const Icon(Icons.broken_image);
                },
              ),
              SizedBox(width: width * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(bloodType, style: TextStyleHelper.h2(context)),
                      SizedBox(width: width * 0.03),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 4,
                          bottom: 4,
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
                  Center(
                    child: Text(
                      'City Hospital',
                      style: TextStyleHelper.small(context),
                    ),
                  ),
                ],
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
          SizedBox(height: height * 0.01),
          isFirst
              ? CustomButton(
                  text: 'Accept Request',
                  height: height * 0.07,
                  backgroundColor: AppColors.primary,
                  isEnabled: true,
                )
              : CustomButton(
                  text: 'View Details',
                  height: height * 0.07,
                  isEnabled: true,
                  backgroundColor: AppColors.popover,
                ),
        ],
      ),
    );
  }
}
