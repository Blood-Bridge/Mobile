import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/widgets/submit_request_sheet.dart';
import 'package:blood_bridge/features/notifications/presentation/views/notifications_screen.dart';

class ReceiverAppBar extends StatefulWidget {
  const ReceiverAppBar({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  State<ReceiverAppBar> createState() => _ReceiverAppBarState();
}

class _ReceiverAppBarState extends State<ReceiverAppBar> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * 0.36,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 2)),
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.width * .03),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.bloodBridge, style: TextStyleHelper.h1(context)),
                    Text(
                      context.l10n.receiverDashboard,
                      style: TextStyleHelper.xs(context),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.to(() => const NotificationsScreen()),
                  icon: Icon(
                    Icons.notifications_outlined,
                    size: widget.width * 0.05,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.toNamed('/settings'),
                  icon: Icon(Icons.settings, size: widget.width * 0.05),
                ),
              ],
            ),

            SizedBox(height: widget.height * 0.02),
            GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  const SubmitRequestSheet(isEmergency: true),
                  isScrollControlled: true,
                );
              },
              child: Container(
                height: widget.height * 0.085,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primaryForeground,
                      size: 18,
                    ),
                    SizedBox(width: widget.width * .05),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.emergencyRequest,
                          style: TextStyleHelper.h4(context),
                        ),
                        Text(
                          context.l10n.instantDonorNotification,
                          style: TextStyleHelper.xs(
                            context,
                          ).copyWith(color: AppColors.primaryForeground),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: widget.height * 0.02),

            GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  const SubmitRequestSheet(isEmergency: false),
                  isScrollControlled: true,
                );
              },
              child: Container(
                height: widget.height * 0.085,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        context.l10n.requestBlood,
                        style: TextStyleHelper.small(
                          context,
                        ).copyWith(color: AppColors.primaryForeground),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
