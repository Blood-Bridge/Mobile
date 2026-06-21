import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/profile/data/repositories/profile_repository_mock.dart';
import 'package:blood_bridge/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:blood_bridge/features/profile/presentation/cubit/profile_state.dart';
import 'package:blood_bridge/features/profile/presentation/widgets/blood_type_card.dart';
import 'package:blood_bridge/features/profile/presentation/widgets/preference_switch_tile.dart';
import 'package:blood_bridge/features/profile/presentation/widgets/profile_header.dart';
import 'package:blood_bridge/features/profile/presentation/widgets/profile_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Entry point for the Profile screen.
///
/// Provides [ProfileCubit] scoped to this screen. Swap
/// `ProfileRepositoryMock()` for `ProfileRepositoryImpl()` once the
/// backend endpoints are ready — no other code needs to change.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ProfileRepositoryMock())..loadProfile(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: AppColors.textMuted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<ProfileCubit>().loadProfile(),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text('Retry', style: TextStyle(color: AppColors.primaryForeground)),
                    ),
                  ],
                ),
              ),
            );
          }

          final loaded = state as ProfileLoaded;
          final profile = loaded.profile;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProfileHeader(name: profile.name, verifiedSince: profile.verifiedSince),
                const SizedBox(height: 16),
                ProfileInfoTile(icon: Icons.phone_outlined, label: profile.phone),
                ProfileInfoTile(icon: Icons.email_outlined, label: profile.email),
                ProfileInfoTile(icon: Icons.location_on_outlined, label: profile.location),
                const SizedBox(height: 16),
                BloodTypeCard(bloodType: profile.bloodType),
                const SizedBox(height: 24),
                const Text(
                  'Preferences',
                  style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                PreferenceSwitchTile(
                  label: 'Emergency Notifications',
                  subtitle: 'Get notified',
                  value: profile.emergencyNotificationsEnabled,
                  enabled: !loaded.isUpdating,
                  onChanged: (value) =>
                      context.read<ProfileCubit>().toggleEmergencyNotifications(value),
                ),
                PreferenceSwitchTile(
                  label: 'Location Sharing',
                  subtitle: 'Help nearby hospitals find you',
                  value: profile.locationSharingEnabled,
                  enabled: !loaded.isUpdating,
                  onChanged: (value) =>
                      context.read<ProfileCubit>().toggleLocationSharing(value),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
