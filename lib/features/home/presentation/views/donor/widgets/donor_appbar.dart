import 'package:blood_bridge/constants.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/utiles/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DonorAppBar extends StatefulWidget {
  const DonorAppBar({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  State<DonorAppBar> createState() => _DonorAppBarState();
}

class _DonorAppBarState extends State<DonorAppBar> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * 0.34,
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
                      'Ready to Save Lives',
                      style: TextStyleHelper.xs(context),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.notifications, size: widget.width * 0.04),
                SizedBox(width: widget.width * 0.03),
                Icon(Icons.settings, size: widget.width * 0.04),
              ],
            ),

            SizedBox(height: widget.height * 0.02),

            Container(
              height: widget.height * 0.15,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  SizedBox(width: widget.width * 0.01),

                  SvgPicture.asset(
                    Assets.imagesDropIcon,
                    width: widget.width * 0.1,
                  ),
                  SizedBox(width: widget.width * 0.02),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEnabled
                            ? 'Available to Donate'
                            : 'Not Available to Donate',
                        style: TextStyleHelper.h4(context),
                      ),
                      Text('Blood Type:', style: TextStyleHelper.xs(context)),
                      Text('A+', style: TextStyleHelper.xs(context)),
                    ],
                  ),

                  const Spacer(),

                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: isEnabled,
                      onChanged: (value) {
                        setState(() {
                          isEnabled = value;
                        });
                      },
                      activeTrackColor: AppColors.primary,
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
