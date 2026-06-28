import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:blood_bridge/features/hospital_profile/presentation/cubit/hospital_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HospitalProfileScreen extends StatelessWidget {
  const HospitalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HospitalProfileCubit()..fetchProfile(),
      child: const _HospitalProfileBody(),
    );
  }
}

class _HospitalProfileBody extends StatelessWidget {
  const _HospitalProfileBody();

  static const _govs = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Luxor',
    'Aswan',
    'Mansoura',
    'Tanta',
    'Ismailia',
    'Suez',
    'Port Said',
    'Zagazig',
    'Asyut',
    'Sohag',
    'Qena',
    'Minya',
    'Beni Suef',
    'Fayoum',
    'Damanhur',
    'Damietta',
    'Kafr el-Sheikh',
    'Shibin el-Kom',
    'Banha',
    'Arish',
    'Marsa Matruh',
  ];
  static const _types = [
    'Government',
    'Private',
    'University',
    'Military',
    'Specialized',
  ];

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
          onPressed: () => Get.back(),
        ),
        title: Text('Hospital Profile', style: TextStyleHelper.h1(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: AppColors.foreground,
            onPressed: () =>
                context.read<HospitalProfileCubit>().fetchProfile(),
          ),
        ],
      ),
      body: BlocConsumer<HospitalProfileCubit, HospitalProfileState>(
        listener: (context, state) {
          if (state is HospitalProfileError) {
            showSnackBar('Error', state.message, SnackbarType.error);
          }
        },
        builder: (context, state) {
          if (state is HospitalProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HospitalProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyleHelper.body(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<HospitalProfileCubit>().fetchProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is HospitalProfileLoaded) {
            final p = state.profile;
            final width = MediaQuery.of(context).size.width;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: 16,
              ),
              child: Column(
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_hospital,
                            size: 52,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          p.name.isNotEmpty ? p.name : 'Hospital',
                          style: TextStyleHelper.h2(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.email,
                          style: TextStyleHelper.bodyMuted(context),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _badge(
                              context,
                              p.role.toUpperCase(),
                              AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            _badge(
                              context,
                              p.isActive ? 'ACTIVE' : 'INACTIVE',
                              p.isActive ? AppColors.success : Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Contact
                  _buildCard(
                    context,
                    title: 'Contact Information',
                    icon: Icons.contact_phone_outlined,
                    children: [
                      _tile(context, 'Phone', p.phone),
                      const Divider(color: AppColors.border),
                      _tile(context, 'Email', p.email),
                      const Divider(color: AppColors.border),
                      _tile(context, 'Governorate', p.governorate),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Details
                  _buildCard(
                    context,
                    title: 'Hospital Details',
                    icon: Icons.apartment_outlined,
                    children: [
                      _tile(context, 'Hospital Type', p.hospitalType),
                      const Divider(color: AppColors.border),
                      _tile(
                        context,
                        'License Number',
                        p.licenseNumber.isNotEmpty ? p.licenseNumber : '—',
                      ),
                      const Divider(color: AppColors.border),
                      _tile(
                        context,
                        'Capacity',
                        p.capacity > 0 ? '${p.capacity} beds' : '—',
                      ),
                      const Divider(color: AppColors.border),
                      _tile(
                        context,
                        'Blood Bank',
                        p.hasBloodBank ? 'Available ✓' : 'Not Available',
                        highlight: p.hasBloodBank,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Edit button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => _showEditDialog(context, p),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Edit Profile',
                        style: TextStyleHelper.small(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, dynamic p) {
    final cubit = context.read<HospitalProfileCubit>();
    final nameCtrl = TextEditingController(text: p.name);
    final phoneCtrl = TextEditingController(text: p.phone);
    final licenseCtrl = TextEditingController(text: p.licenseNumber);
    final capacityCtrl = TextEditingController(
      text: p.capacity > 0 ? '${p.capacity}' : '',
    );
    String selectedGov = _govs.contains(p.governorate)
        ? p.governorate
        : _govs.first;
    String selectedType = _types.contains(p.hospitalType)
        ? p.hospitalType
        : _types.first;
    bool selectedBloodBank = p.hasBloodBank;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(
            'Edit Hospital Profile',
            style: TextStyleHelper.h3(context),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _editField(
                  context,
                  'Hospital Name',
                  nameCtrl,
                  Icons.local_hospital_outlined,
                ),
                const SizedBox(height: 12),
                _editField(
                  context,
                  'Phone Number',
                  phoneCtrl,
                  Icons.phone_outlined,
                ),
                const SizedBox(height: 12),
                _editField(
                  context,
                  'License Number',
                  licenseCtrl,
                  Icons.badge_outlined,
                ),
                const SizedBox(height: 12),
                _editField(
                  context,
                  'Capacity (beds)',
                  capacityCtrl,
                  Icons.bed_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Text(
                  'Governorate',
                  style: TextStyleHelper.small(
                    context,
                  ).copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedGov,
                  dropdownColor: AppColors.card,
                  style: const TextStyle(color: Colors.white),
                  items: _govs
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedGov = v!),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.bg,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hospital Type',
                  style: TextStyleHelper.small(
                    context,
                  ).copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  dropdownColor: AppColors.card,
                  style: const TextStyle(color: Colors.white),
                  items: _types
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedType = v!),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.bg,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Blood Bank',
                  style: TextStyleHelper.small(
                    context,
                  ).copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedBloodBank = true),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            border: Border.all(
                              color: selectedBloodBank
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Available',
                              style: TextStyleHelper.small(context).copyWith(
                                color: selectedBloodBank
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedBloodBank = false),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            border: Border.all(
                              color: !selectedBloodBank
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Not Available',
                              style: TextStyleHelper.small(context).copyWith(
                                color: !selectedBloodBank
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                cubit.updateProfile(
                  name: nameCtrl.text.trim(),
                  phoneNumber: phoneCtrl.text.trim(),
                  governorate: selectedGov,
                  licenseNumber: licenseCtrl.text.trim(),
                  hospitalType: selectedType,
                  capacity: int.tryParse(capacityCtrl.text) ?? 0,
                  hasBloodBank: selectedBloodBank,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editField(
    BuildContext context,
    String label,
    TextEditingController ctrl,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyleHelper.small(
            context,
          ).copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
            filled: true,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _badge(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyleHelper.xs(
          context,
        ).copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCard(
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

  Widget _tile(
    BuildContext context,
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
              value.isNotEmpty ? value : '—',
              textAlign: TextAlign.end,
              style: TextStyleHelper.small(context).copyWith(
                color: highlight ? AppColors.primary : Colors.white,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
