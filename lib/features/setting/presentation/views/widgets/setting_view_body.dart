import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/language_cubit/cubit/language_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_state.dart';
import 'package:blood_bridge/features/setting/presentation/views/widgets/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';

import '../widgets/arrow_item.dart';
import '../widgets/language_selector.dart';
import '../widgets/toggle_item.dart';

class SettingViewBody extends StatefulWidget {
  const SettingViewBody({super.key});

  @override
  State<SettingViewBody> createState() => _SettingViewBodyState();
}

class _SettingViewBodyState extends State<SettingViewBody> {
  bool _locationSharing = true;
  bool _profileVisibility = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 99, 99),
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.foreground,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings', style: TextStyleHelper.h1(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        children: [
          const LanguageSelector(),

          // ✅ Notifications - NotificationsCubit من main.dart
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              return SettingsGroup(
                sectionTitle: 'Notifications',
                children: [
                  ToggleItem(
                    title: 'Emergency Alerts',
                    subtitle: 'Critical blood requests',
                    value: state.emergencyAlerts,
                    onChanged: (val) => context
                        .read<NotificationsCubit>()
                        .toggleEmergencyAlerts(val),
                  ),
                  ToggleItem(
                    title: 'Request Notifications',
                    subtitle: 'Standard blood requests',
                    value: state.requestNotifications,
                    onChanged: (val) => context
                        .read<NotificationsCubit>()
                        .toggleRequestNotifications(val),
                  ),
                  ToggleItem(
                    title: 'Donation Reminders',
                    subtitle: 'When eligible to donate again',
                    value: state.donationReminders,
                    onChanged: (val) => context
                        .read<NotificationsCubit>()
                        .toggleDonationReminders(val),
                  ),
                ],
              );
            },
          ),

          // setState — تغييرات محلية
          SettingsGroup(
            sectionTitle: 'Privacy',
            children: [
              ToggleItem(
                title: 'Location Sharing',
                subtitle: 'For nearby matching',
                value: _locationSharing,
                onChanged: (val) => setState(() => _locationSharing = val),
              ),
              ToggleItem(
                title: 'Profile Visibility',
                subtitle: 'Show to other users',
                value: _profileVisibility,
                onChanged: (val) => setState(() => _profileVisibility = val),
              ),
            ],
          ),
          SettingsGroup(
            sectionTitle: 'Preferences',
            children: [
              ToggleItem(
                title: 'Dark Mode',
                subtitle: 'Always on for eye comfort',
                value: _darkMode,
                onChanged: (val) => setState(() => _darkMode = val),
              ),
              ArrowItem(title: 'Search Radius', subtitle: '5 km', onTap: () {}),
            ],
          ),
          SettingsGroup(
            sectionTitle: 'Support',
            children: [
              ArrowItem(title: 'Help Center', onTap: () {}),
              ArrowItem(title: 'Contact Support', onTap: () {}),
              ArrowItem(title: 'About', onTap: () {}),
            ],
          ),

          // ── FOOTER ──────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.textMuted,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Privacy Policy',
                      style: TextStyleHelper.small(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: AppColors.primary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyleHelper.small(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Blood Bridge v1.0.0',
              style: TextStyleHelper.xs(context),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
