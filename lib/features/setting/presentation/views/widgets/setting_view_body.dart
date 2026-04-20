import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/Preferences_cubit/cubit/preferences_state.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/language_cubit/cubit/language_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/notifications_cubit/cubit/notifications_state.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/preferences_cubit/cubit/preferences_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/privacy_cubit/cubit/privacy_cubit.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/privacy_cubit/cubit/privacy_state.dart';
import 'package:blood_bridge/features/setting/presentation/views/widgets/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';

import '../widgets/arrow_item.dart';
import '../widgets/language_selector.dart';
import '../widgets/toggle_item.dart';

class SettingViewBody extends StatelessWidget {
  const SettingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
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
          // ✅ Language
          const LanguageSelector(),

          // ✅ Notifications
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

          // ✅ Privacy
          BlocBuilder<PrivacyCubit, PrivacyState>(
            builder: (context, state) {
              return SettingsGroup(
                sectionTitle: 'Privacy',
                children: [
                  ToggleItem(
                    title: 'Location Sharing',
                    subtitle: 'For nearby matching',
                    value: state.locationSharing,
                    onChanged: (val) =>
                        context.read<PrivacyCubit>().toggleLocationSharing(val),
                  ),
                  ToggleItem(
                    title: 'Profile Visibility',
                    subtitle: 'Show to other users',
                    value: state.profileVisibility,
                    onChanged: (val) => context
                        .read<PrivacyCubit>()
                        .toggleProfileVisibility(val),
                  ),
                ],
              );
            },
          ),

          // ✅ Preferences
          BlocBuilder<PreferencesCubit, PreferencesState>(
            builder: (context, state) {
              return SettingsGroup(
                sectionTitle: 'Preferences',
                children: [
                  ToggleItem(
                    title: 'Dark Mode',
                    subtitle: 'Always on for eye comfort',
                    value: state.darkMode,
                    onChanged: (val) =>
                        context.read<PreferencesCubit>().toggleDarkMode(val),
                  ),
                  ArrowItem(
                    title: 'Search Radius',
                    subtitle: '${state.searchRadius.toInt()} km',
                    onTap: () => _showRadiusSheet(context, state.searchRadius),
                  ),
                ],
              );
            },
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

  // ── Search Radius Bottom Sheet ───────────────────────
  void _showRadiusSheet(BuildContext context, double currentRadius) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<PreferencesCubit>(),
        child: _RadiusSheet(currentRadius: currentRadius),
      ),
    );
  }
}

// ── Radius Bottom Sheet Widget ───────────────────────────
class _RadiusSheet extends StatelessWidget {
  final double currentRadius;

  const _RadiusSheet({required this.currentRadius});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Search Radius', style: TextStyleHelper.h3(context)),
              const SizedBox(height: 8),
              Text(
                '${state.searchRadius.toInt()} km',
                style: TextStyleHelper.h2(
                  context,
                ).copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Slider(
                value: state.searchRadius,
                min: 1,
                max: 50,
                divisions: 49,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.accent,
                onChanged: (val) =>
                    context.read<PreferencesCubit>().updateSearchRadius(val),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1 km', style: TextStyleHelper.xs(context)),
                  Text('50 km', style: TextStyleHelper.xs(context)),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
