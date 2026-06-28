import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/utiles/app_images.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/cubit/cubit/donor_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:blood_bridge/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:blood_bridge/features/notifications/presentation/views/notifications_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonorAppBar extends StatefulWidget {
  const DonorAppBar({
    super.key,
    required this.width,
    required this.height,
    required this.cubit,
  });

  final double width;
  final double height;
  final DonorCubit cubit;
  @override
  State<DonorAppBar> createState() => _DonorAppBarState();
}

class _DonorAppBarState extends State<DonorAppBar> {
  late bool isEnabled;
  @override
  void initState() {
    isEnabled = HiveHelper.isAvailability();
    super.initState();
  }

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
                    Text(context.l10n.bloodBridge, style: TextStyleHelper.h1(context)),
                    Text(
                      context.l10n.donorDashboard,
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
                            ? context.l10n.available
                            : context.l10n.notAvailable,
                        style: TextStyleHelper.h4(context),
                      ),
                      Text(
                        context.l10n.bloodType,
                        style: TextStyleHelper.xs(context),
                      ),
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileLoaded) {
                            return Text(
                              state.profile.bloodType,
                              style: TextStyleHelper.xs(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            );
                          }
                          return Text(
                            '...',
                            style: TextStyleHelper.xs(context),
                          );
                        },
                      ),
                    ],
                  ),

                  const Spacer(),

                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: widget.cubit.isAvilable,
                      onChanged: widget.cubit.isLoading
                          ? null
                          : (value) async {
                              await widget.cubit.changeAvilablity(
                                isAvailable: !widget.cubit.isAvilable,
                              );
                              print("$value DDDDD");
                              setState(() {});
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
