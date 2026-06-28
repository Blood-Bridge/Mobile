import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/widgets/custom_button.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/auth/presentation/views/login_screen.dart';
import 'package:blood_bridge/features/permissions/presntation/cubit/permissions_cubit.dart';
import 'package:blood_bridge/features/permissions/presntation/views/widgets/permission_card.dart';
import 'package:blood_bridge/core/models/user_role.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/donor_screen.dart';
import 'package:blood_bridge/features/home/presentation/views/reciver/receiver_screen.dart';
import 'package:blood_bridge/features/hospital_dashboard/presentation/views/hospital_dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    final cubit = context.read<PermissionsCubit>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(width * 0.03),
        child: BlocConsumer<PermissionsCubit, PermissionsState>(
          listener: (context, state) {
            switch (state) {
              case PermissionsUpdated():
                showSnackBar(
                  "permissions done",
                  "All permissions are granted",
                  SnackbarType.success,
                );
                break;
              case PermissionsLocationAccessError():
                showSnackBar(
                  "Error",
                  "Location permission is required",
                  SnackbarType.error,
                );
                break;
              case PermissionsLocationAccessSuccess():
                showSnackBar(
                  "Success",
                  "Location permission is granted",
                  SnackbarType.success,
                );
                break;
              case PermissionsNotificationAccessSuccess():
                showSnackBar(
                  "Success",
                  "Notification permission is granted",
                  SnackbarType.success,
                );
                break;
              case PermissionsNotificationAccessError():
                showSnackBar(
                  "Error",
                  "Notification permission is required",
                  SnackbarType.error,
                );
                break;
              default:
                break;
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                spacing: height * 0.02,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.08),
                  Text(
                    'Enable Permissions',
                    style: TextStyleHelper.h1(context),
                  ),
                  Text(
                    'These help us provide faster emergency responses',
                    style: TextStyleHelper.xs(context),
                  ),
                  PermissionCard(
                    height: height,
                    width: width,
                    title: context.l10n.locationAccess,
                    description:
                        'Find nearby donors and requests quickly in emergencies',
                    isAccessed: cubit.isLocationAccessGranted,
                    icon: Icons.location_on_outlined,
                    onTap: () {
                      cubit.grantLocationPermission();
                    },
                  ),
                  PermissionCard(
                    height: height,
                    width: width,
                    title: context.l10n.notifications,
                    description:
                        'Receive urgent blood requests and emergency alerts',
                    isAccessed: cubit.isNotificationAccessGranted,
                    icon: CupertinoIcons.bell_solid,
                    onTap: () {
                      cubit.grantNotificationPermission();
                    },
                  ),
                  SizedBox(height: height * 0.1),

                  CustomButton(
                    text: cubit.isEnabled
                        ? 'Continue'
                        : 'Grant all permissions to continue',
                    isEnabled: cubit.isEnabled,
                    onPressed: () {
                      final roleStr = HiveHelper.getUserRole();
                      final role = UserRole.fromString(roleStr);
                      switch (role) {
                        case UserRole.donor:
                          Get.offAll(() => const DonorScreen());
                          break;
                        case UserRole.recipient:
                          Get.offAll(() => const ReceiverScreen());
                          break;
                        case UserRole.hospital:
                          Get.offAll(() => const HospitalDashboardScreen());
                          break;
                        default:
                          Get.offAll(() => LoginScreen());
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
