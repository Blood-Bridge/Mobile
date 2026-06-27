import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/cubit/admin_requests_cubit.dart';
import 'package:blood_bridge/features/admin_dashboard/presentation/cubit/admin_requests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  String? _selectedStatus;
  String? _selectedGovernorate;

  final List<String> _statuses = [
    'Pending',
    'Analyzing',
    'Open',
    'Accepted',
    'Completed',
    'Cancelled',
    'Expired',
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
    context.read<AdminRequestsCubit>().fetchRequests();
  }

  void _applyFilters() {
    context.read<AdminRequestsCubit>().fetchRequests(
          status: _selectedStatus,
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
          icon: Icon(Icons.arrow_back_ios, color: AppColors.foreground, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text('Manage Requests', style: TextStyleHelper.h1(context)),
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filters',
                  style: TextStyleHelper.small(context).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.muted,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStatus,
                            hint: Text('Status', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                            dropdownColor: AppColors.card,
                            isExpanded: true,
                            items: _statuses.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 13)),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.muted,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGovernorate,
                            hint: Text('Governorate', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                            dropdownColor: AppColors.card,
                            isExpanded: true,
                            items: _governorates.map((gov) {
                              return DropdownMenuItem(
                                value: gov,
                                child: Text(gov, style: const TextStyle(color: Colors.white, fontSize: 13)),
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
                    padding: const EdgeInsets.only(top: 12),
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
            child: BlocBuilder<AdminRequestsCubit, AdminRequestsState>(
              builder: (context, state) {
                if (state is AdminRequestsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AdminRequestsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: AppColors.primary),
                        const SizedBox(height: 16),
                        Text(state.message, style: TextStyleHelper.body(context)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AdminRequestsLoaded) {
                  final list = state.requests;
                  if (list.isEmpty) {
                    return Center(
                      child: Text('No requests match the selected filters.', style: TextStyleHelper.bodyMuted(context)),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _applyFilters(),
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        Color statusColor = Colors.orange;
                        if (item.status == 'Completed' || item.status == 'Open') statusColor = Colors.green;
                        if (item.status == 'Cancelled' || item.status == 'Expired') statusColor = Colors.red;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Request #${item.requestId}',
                                    style: TextStyleHelper.small(context).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: statusColor.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      item.status,
                                      style: TextStyleHelper.xs(context).copyWith(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow('Blood Type', item.bloodTypeDisplay),
                              const SizedBox(height: 6),
                              _buildInfoRow('Quantity', '${item.quantity} Units'),
                              const SizedBox(height: 6),
                              _buildInfoRow('Hospital ID', '#${item.hospitalId}'),
                              const SizedBox(height: 6),
                              _buildInfoRow('Created At', item.createdAt.toLocal().toString().split('.').first),
                              if (item.status != 'Cancelled' && item.status != 'Completed' && item.status != 'Expired')
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () => _confirmCancel(context, item.requestId),
                                      icon: const Icon(Icons.cancel, size: 16, color: Colors.red),
                                      label: const Text('Cancel Request', style: TextStyle(color: Colors.red, fontSize: 12)),
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

                return const SizedBox();
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
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _confirmCancel(BuildContext context, int requestId) {
    showDialog(
      context: context,
      builder: (dlgContext) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Cancel Request', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to cancel request #$requestId?', style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgContext),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dlgContext);
              context.read<AdminRequestsCubit>().deleteRequest(requestId);
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
