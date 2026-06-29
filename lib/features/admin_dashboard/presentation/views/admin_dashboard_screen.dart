import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../cubit/admin_dashboard_cubit.dart';
import 'widgets/admin_section.dart';
import 'widgets/admin_setting_item.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminDashboardCubit()..fetchDashboardData(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0A0A),
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.adminDashboard,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.5),
            child: Container(color: const Color(0xFF262626), height: 1.5),
          ),
        ),
        body: const _AdminDashboardBody(),
      ),
    );
  }
}

class _AdminDashboardBody extends StatefulWidget {
  const _AdminDashboardBody();

  @override
  State<_AdminDashboardBody> createState() => _AdminDashboardBodyState();
}

class _AdminDashboardBodyState extends State<_AdminDashboardBody> {
  bool _emailNotifications = true;
  bool _smsNotifications = true;
  bool _maintenanceMode = false;
  int _sessionTimeoutMinutes = 30;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFC97777)),
          );
        }

        if (state.error != null) {
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('OVERVIEW'),
              const SizedBox(height: 12),
              _buildOverviewGrid(state),
              const SizedBox(height: 24),

              AdminSection(
                title: 'MANAGE',
                children: [
                  AdminSettingItem(
                    icon: Icons.people_outline,
                    iconBgColor: const Color(0xFFFB2C36).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.manageDonors,
                    subtitle: 'View, filter and delete donors',
                    hasArrow: true,
                    onTap: () => Get.toNamed('/admin/donors'),
                  ),
                  AdminSettingItem(
                    icon: Icons.receipt_long_outlined,
                    iconBgColor: const Color(0xFFFFB020).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.manageRequests,
                    subtitle: 'View, track and cancel blood requests',
                    hasArrow: true,
                    onTap: () => Get.toNamed('/admin/requests'),
                  ),
                  AdminSettingItem(
                    icon: Icons.favorite_outline,
                    iconBgColor: const Color(0xFF00C950).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.manageDonations,
                    subtitle: 'View and delete donation records',
                    hasArrow: true,
                    onTap: () => Get.toNamed('/admin/donations'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              AdminSection(
                title: 'GENERAL',
                children: [
                  AdminSettingItem(
                    icon: Icons.language,
                    iconBgColor: const Color(0xFF2B7FFF).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.systemLanguage,
                    subtitle: 'English',
                    hasArrow: true,
                    onTap: () => Get.toNamed('/admin/language'),
                  ),
                  AdminSettingItem(
                    icon: Icons.timer_outlined,
                    iconBgColor: const Color(0xFFAD46FF).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.sessionTimeout,
                    subtitle: '$_sessionTimeoutMinutes minutes',
                    hasArrow: true,
                    onTap: () => _showTimeoutDialog(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              AdminSection(
                title: 'NOTIFICATIONS',
                children: [
                  AdminSettingItem(
                    icon: Icons.email_outlined,
                    iconBgColor: const Color(0xFF00C950).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.emailNotifications,
                    subtitle: _emailNotifications ? 'Enabled' : 'Disabled',
                    trailing: _buildSwitch(
                      _emailNotifications,
                      (val) => setState(() {
                        _emailNotifications = val;
                        _showSnackBar(
                          'Email notifications ${val ? "enabled" : "disabled"}',
                        );
                      }),
                    ),
                  ),
                  AdminSettingItem(
                    icon: Icons.sms_outlined,
                    iconBgColor: const Color(0xFF2B7FFF).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.smsNotifications,
                    subtitle: _smsNotifications ? 'Enabled' : 'Disabled',
                    trailing: _buildSwitch(
                      _smsNotifications,
                      (val) => setState(() {
                        _smsNotifications = val;
                        _showSnackBar(
                          'SMS notifications ${val ? "enabled" : "disabled"}',
                        );
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              AdminSection(
                title: 'DATABASE',
                children: [
                  AdminSettingItem(
                    icon: Icons.backup_outlined,
                    iconBgColor: const Color(0xFF2B7FFF).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.backupDatabase,
                    subtitle: 'Manage backups & schedules',
                    hasArrow: true,
                    onTap: () => Get.toNamed('/admin/backup'),
                  ),
                  AdminSettingItem(
                    icon: Icons.list_alt_outlined,
                    iconBgColor: const Color(0xFFFF6900).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.viewSystemLogs,
                    subtitle: 'Last 7 days',
                    hasArrow: true,
                    onTap: () => Get.toNamed('/admin/logs'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              AdminSection(
                title: AppLocalizations.of(context)!.dangerZone,
                isDanger: true,
                children: [
                  AdminSettingItem(
                    icon: Icons.build_circle_outlined,
                    iconBgColor: const Color(0xFFFF6900).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.maintenanceMode,
                    subtitle: _maintenanceMode ? 'Enabled' : 'Disabled',
                    trailing: _buildSwitch(
                      _maintenanceMode,
                      (val) => setState(() {
                        _maintenanceMode = val;
                        _showSnackBar(
                          val
                              ? 'System is now in Maintenance Mode'
                              : 'System is back online',
                          isWarning: val,
                        );
                      }),
                    ),
                  ),
                  AdminSettingItem(
                    icon: Icons.restart_alt_outlined,
                    iconBgColor: const Color(0xFFFB2C36).withOpacity(0.2),
                    title: AppLocalizations.of(context)!.resetSystem,
                    subtitle: 'Complete system reset',
                    titleColor: const Color(0xFFFF6467),
                    hasArrow: true,
                    onTap: () => _showResetDialog(),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AdminDashboardCubit>().fetchDashboardData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC97777),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.refreshData,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF6A7282),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildOverviewGrid(AdminDashboardState state) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Users',
          state.userCount.toString(),
          Icons.people,
          const Color(0xFF2B7FFF),
        ),
        _buildStatCard(
          'Donors',
          state.donorCount.toString(),
          Icons.favorite,
          const Color(0xFFFB2C36),
        ),
        _buildStatCard(
          'Hospitals',
          state.hospitalCount.toString(),
          Icons.local_hospital,
          const Color(0xFF00C950),
        ),
        _buildStatCard(
          'Requests',
          state.totalRequests.toString(),
          Icons.bloodtype,
          const Color(0xFFFF6900),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF262626), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF99A1AF),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color.withOpacity(0.8), size: 20),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged) {
    return Transform.scale(
      scale: 0.8,
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFC97777),
        trackColor: const Color(0xFF4A5565),
      ),
    );
  }

  void _showSnackBar(String message, {bool isWarning = false}) {
    Get.snackbar(
      isWarning ? 'Warning' : 'Settings Updated',
      message,
      backgroundColor: isWarning ? Colors.amber[900] : Colors.green[800],
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showTimeoutDialog() {
    Get.dialog(
      SimpleDialog(
        backgroundColor: const Color(0xFF121212),
        title: Text(
          AppLocalizations.of(context)!.sessionTimeout,
          style: TextStyle(color: Colors.white),
        ),
        children: [15, 30, 60, 120].map((mins) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _sessionTimeoutMinutes = mins;
              });
              Get.back();
              _showSnackBar('Session timeout set to $mins minutes');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '$mins minutes',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showResetDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF121212),
        title: Text(
          AppLocalizations.of(context)!.resetSystem,
          style: TextStyle(color: Color(0xFFFF6467)),
        ),
        content: Text(
          AppLocalizations.of(
            context,
          )!.thisWillCompletelyClearTheSystemDatabaseAndLogFilesThisActio,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFFC97777)),
                ),
                barrierDismissible: false,
              );
              await Future.delayed(const Duration(seconds: 2));
              Get.back();
              _showSnackBar(
                'System database reset successfully',
                isWarning: true,
              );
            },
            child: Text(
              AppLocalizations.of(context)!.resetEverything,
              style: TextStyle(
                color: Color(0xFFFF6467),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
