import 'package:blood_bridge/constants.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/utiles/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                    Text('Blood Bridge', style: TextStyleHelper.h1(context)),
                    Text(
                      'Find donors quickly',
                      style: TextStyleHelper.xs(context),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.settings, size: widget.width * 0.04),
              ],
            ),

            SizedBox(height: widget.height * 0.02),
            GestureDetector(
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
                          'Emergency Request',
                          style: TextStyleHelper.h4(context),
                        ),
                        Text(
                          'Instant donor notification',
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

            Container(
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
                      'Request Blood',
                      style: TextStyleHelper.small(
                        context,
                      ).copyWith(color: AppColors.primaryForeground),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
