import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/cubit/admin_donations_cubit.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/cubit/admin_donations_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AdminDonationsScreen extends StatefulWidget {
  AdminDonationsScreen({super.key});

  @override
  State<AdminDonationsScreen> createState() => _AdminDonationsScreenState();
}

class _AdminDonationsScreenState extends State<AdminDonationsScreen> {
  String? _selectedStatus;
  String? _selectedGovernorate;

  final List<String> _statuses = [
    'Pending',
    'DonorConfirmed',
    'PatientConfirmed',
    'Confirmed',
    'Cancelled',
  ];

  final List<String> _governorates = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Qalyubia',
    'PortSaid',
    'Suez',
    'Gharbia',
    'Dakahlia',
    'Ismailia',
    'Asyut',
    'Fayoum',
    'Sharqia',
    'Aswan',
    'Damietta',
    'Minya',
    'BeniSuef',
    'Hurghada',
    'Qena',
    'Sohag',
    'Luxor',
    'Matrouh',
    'NorthSinai',
    'SouthSinai',
    'NewValley',
    'Beheira',
    'KafrElSheikh',
    'Monufia',
  ];

  @override
  void initState() {
    super.initState();
    context.read<AdminDonationsCubit>().fetchDonations();
  }

  void _applyFilters() {
    context.read<AdminDonationsCubit>().fetchDonations(
      confirmationStatus: _selectedStatus,
      governorate: _selectedGovernorate,
    );
  }

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
        title: Text('Manage Donations', style: TextStyleHelper.h1(context)),
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
                  'Filters',
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
                            value: _selectedStatus,
                            hint: Text(
                              'Status',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                            dropdownColor: AppColors.card,
                            isExpanded: true,
                            items: _statuses.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => _selectedStatus = val);
                              _applyFilters();
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
                              'Governorate',
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
                              setState(() => _selectedGovernorate = val);
                              _applyFilters();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedStatus != null || _selectedGovernorate != null)
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedStatus = null;
                            _selectedGovernorate = null;
                          });
                          _applyFilters();
                        },
                        child: Text(
                          'Clear Filters',
                          style: TextStyleHelper.xs(context).copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<AdminDonationsCubit, AdminDonationsState>(
              builder: (context, state) {
                if (state is AdminDonationsLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is AdminDonationsError) {
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
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AdminDonationsLoaded) {
                  final list = state.donations;
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        'No donations match the selected filters.',
                        style: TextStyleHelper.bodyMuted(context),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _applyFilters(),
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        Color statusColor = Colors.orange;
                        if (item.confirmationStatus == 'Confirmed')
                          statusColor = Colors.green;
                        if (item.confirmationStatus == 'Cancelled')
                          statusColor = Colors.red;

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Donation #${item.donationProcessId}',
                                    style: TextStyleHelper.small(
                                      context,
                                    ).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: statusColor.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      item.confirmationStatus,
                                      style: TextStyleHelper.xs(context)
                                          .copyWith(
                                            color: statusColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              _buildInfoRow('Donor ID', '#${item.donorId}'),
                              SizedBox(height: 6),
                              _buildInfoRow(
                                'Blood Request ID',
                                '#${item.bloodRequestId}',
                              ),
                              SizedBox(height: 6),
                              _buildInfoRow(
                                'Hospital ID',
                                '#${item.hospitalId}',
                              ),
                              SizedBox(height: 6),
                              _buildInfoRow(
                                'Donation Date',
                                item.donationDate
                                    .toLocal()
                                    .toString()
                                    .split(' ')
                                    .first,
                              ),
                              SizedBox(height: 6),
                              _buildInfoRow(
                                'Created At',
                                item.createdAt
                                    .toLocal()
                                    .toString()
                                    .split('.')
                                    .first,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () => _confirmDelete(
                                      context,
                                      item.donationProcessId,
                                    ),
                                    icon: Icon(
                                      Icons.delete,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      context.l10n.deleteRecord,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, int donationId) {
    showDialog(
      context: context,
      builder: (dlgContext) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          context.l10n.deleteDonationRecord,
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to permanently delete donation record #$donationId?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgContext),
            child: Text(
              context.l10n.cancel,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dlgContext);
              context.read<AdminDonationsCubit>().deleteDonation(donationId);
            },
            child: Text(
              context.l10n.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
