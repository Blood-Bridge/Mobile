import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppLocalizations.of(context)!.myProfile,
          style: TextStyleHelper.h1(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProfileCubit>().fetchProfile(),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(state.error, style: TextStyleHelper.body(context)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProfileCubit>().fetchProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: 16,
              ),
              child: Column(
                children: [
                  // User avatar and badge
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile.fullName,
                          style: TextStyleHelper.h2(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.email,
                          style: TextStyleHelper.bodyMuted(context),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            profile.role.toUpperCase(),
                            style: TextStyleHelper.xs(context).copyWith(
                              color: AppColors.primaryForeground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Blood Type Card
                  _buildProfileCard(
                    context,
                    title: AppLocalizations.of(context)!.medicalInformation,
                    icon: Icons.medical_services_outlined,
                    children: [
                      _buildInfoTile(
                        context,
                        'Blood Type',
                        profile.bloodType,
                        isHighlight: true,
                      ),
                      const Divider(color: AppColors.border),
                      _buildInfoTile(
                        context,
                        'Weight',
                        '${profile.weight.toStringAsFixed(1)} kg',
                      ),
                      const Divider(color: AppColors.border),
                      _buildInfoTile(
                        context,
                        'Date of Birth',
                        profile.dateOfBirth.split('T').first,
                      ),
                      const Divider(color: AppColors.border),
                      _buildInfoTile(
                        context,
                        'Medical History',
                        profile.medicalHistory.isEmpty
                            ? 'None reported'
                            : profile.medicalHistory,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Contact Card
                  _buildProfileCard(
                    context,
                    title: AppLocalizations.of(context)!.personalDetails,
                    icon: Icons.person_outline,
                    children: [
                      _buildInfoTile(context, 'Phone Number', profile.phone),
                      const Divider(color: AppColors.border),
                      _buildInfoTile(
                        context,
                        'Governorate',
                        profile.governorate,
                      ),
                      const Divider(color: AppColors.border),
                      _buildInfoTile(
                        context,
                        'National ID',
                        profile.nationalId,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return Center(child: Text(AppLocalizations.of(context)!.noData));
        },
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(title, style: TextStyleHelper.h3(context)),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyleHelper.small(
              context,
            ).copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyleHelper.small(context).copyWith(
                color: isHighlight ? AppColors.primary : Colors.white,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
