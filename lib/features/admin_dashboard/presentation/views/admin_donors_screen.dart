import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/home/presentation/views/donor/cubit/cubit/donor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AdminDonorsScreen extends StatefulWidget {
  AdminDonorsScreen({super.key});

  @override
  State<AdminDonorsScreen> createState() => _AdminDonorsScreenState();
}

class _AdminDonorsScreenState extends State<AdminDonorsScreen> {
  String? _selectedBloodType;
  String? _selectedGovernorate;

  final List<String> _bloodTypes = [
    'OPositive',
    'ONegative',
    'APositive',
    'ANegative',
    'BPositive',
    'BNegative',
    'ABPositive',
    'ABNegative',
  ];

  final List<String> _governorates = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Qalyubia',
    'Sharqia',
    'Dakahliya',
    'Gharbia',
    'Monufia',
    'Beheira',
    'Fayoum',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch initial list
    context.read<DonorCubit>().getAllDonors();
  }

  void _fetchFilteredDonors() {
    context.read<DonorCubit>().getAllDonors(
      bloodType: _selectedBloodType,
      governorate: _selectedGovernorate,
    );
  }

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
          AppLocalizations.of(context)!.adminDonors,
          style: TextStyleHelper.h1(context),
        ),
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.filters,
                  style: TextStyleHelper.small(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.muted,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedBloodType,
                            hint: Text(
                              AppLocalizations.of(context)!.bloodType,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                            dropdownColor: AppColors.card,
                            isExpanded: true,
                            items: _bloodTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedBloodType = val;
                              });
                              _fetchFilteredDonors();
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.muted,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGovernorate,
                            hint: Text(
                              AppLocalizations.of(context)!.governorate,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                            dropdownColor: AppColors.card,
                            isExpanded: true,
                            items: _governorates.map((gov) {
                              return DropdownMenuItem(
                                value: gov,
                                child: Text(
                                  gov,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedGovernorate = val;
                              });
                              _fetchFilteredDonors();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedBloodType != null || _selectedGovernorate != null)
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedBloodType = null;
                          _selectedGovernorate = null;
                        });
                        context.read<DonorCubit>().getAllDonors();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.clearFilters,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Donors List
          Expanded(
            child: BlocConsumer<DonorCubit, DonorState>(
              listener: (context, state) {
                if (state is DonorDeleteSuccess) {
                  Get.snackbar(
                    'Success',
                    'Donor deleted successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  _fetchFilteredDonors();
                } else if (state is DonorsError) {
                  Get.snackbar(
                    'Error',
                    state.message,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              builder: (context, state) {
                if (state is DonorsLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is DonorsError &&
                    _selectedBloodType == null &&
                    _selectedGovernorate == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          state.message,
                          style: TextStyleHelper.body(context),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _fetchFilteredDonors(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text(AppLocalizations.of(context)!.retry),
                        ),
                      ],
                    ),
                  );
                }

                // If loaded
                List<dynamic> donors = [];
                if (state is DonorsSuccess) {
                  // Admin API data might have a wrapper
                  final dynamic data = state.donors;
                  if (data is Map) {
                    donors = data['items'] as List<dynamic>? ?? [];
                  } else if (data is List) {
                    donors = data;
                  }
                }

                if (donors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noDonorsFound,
                          style: TextStyleHelper.bodyMuted(context),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: donors.length,
                  itemBuilder: (context, index) {
                    final d = donors[index] as Map<String, dynamic>;
                    final donorId = d['id'] as int? ?? d['userId'] as int? ?? 0;
                    final donorName =
                        '${d['firstName'] ?? ''} ${d['lastName'] ?? ''}'.trim();
                    final bloodType = d['bloodType'] as String? ?? 'OPositive';
                    final city = d['governorate'] as String? ?? 'N/A';
                    final phone = d['phone'] as String? ?? 'N/A';

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary.withOpacity(
                              0.15,
                            ),
                            child: Text(
                              bloodType
                                  .replaceAll('Positive', '+')
                                  .replaceAll('Negative', '−'),
                              style: TextStyleHelper.h3(
                                context,
                              ).copyWith(color: AppColors.primary),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  donorName.isEmpty
                                      ? '${AppLocalizations.of(context)!.donor} #$donorId'
                                      : donorName,
                                  style: TextStyleHelper.small(
                                    context,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Loc: $city  |  Tel: $phone',
                                  style: TextStyleHelper.xs(
                                    context,
                                  ).copyWith(color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  backgroundColor: AppColors.card,
                                  title: Text(
                                    AppLocalizations.of(context)!.deleteDonor,
                                    style: TextStyleHelper.h3(context),
                                  ),
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.deleteDonorConfirmation,
                                    style: TextStyleHelper.small(context),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style: TextStyle(
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        context.read<DonorCubit>().deleteDonor(
                                          donorId,
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.delete,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
