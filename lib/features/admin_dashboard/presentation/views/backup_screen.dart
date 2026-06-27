import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/admin_section.dart';
import 'widgets/admin_setting_item.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _dailyBackup = true;
  int _retentionDays = 30;
  String _lastCloudBackup = '2 hours ago';
  String _lastLocalBackup = '1 day ago';

  void _triggerBackup(bool isCloud) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: Color(0xFFC97777)),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 2));
    Get.back(); // Dismiss progress dialog

    setState(() {
      if (isCloud) {
        _lastCloudBackup = 'Just now';
      } else {
        _lastLocalBackup = 'Just now';
      }
    });

    Get.snackbar(
      'Backup Complete',
      '${isCloud ? "Cloud" : "Local"} database backup created successfully.',
      backgroundColor: Colors.green[800],
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showRetentionDialog() {
    Get.dialog(
      SimpleDialog(
        backgroundColor: const Color(0xFF121212),
        title: const Text('Retention Period', style: TextStyle(color: Colors.white)),
        children: [7, 15, 30, 90].map((days) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _retentionDays = days;
              });
              Get.back();
              Get.snackbar(
                'Settings Updated',
                'Retention period set to $days days',
                backgroundColor: Colors.green[800],
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '$days days',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Backup Database',
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
          child: Container(
            color: const Color(0xFF262626),
            height: 1.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSection(
              title: 'BACKUP OPTIONS',
              children: [
                AdminSettingItem(
                  icon: Icons.cloud_upload_outlined,
                  iconBgColor: const Color(0xFF2B7FFF).withOpacity(0.2),
                  title: 'Backup to Cloud',
                  subtitle: 'Last backup: $_lastCloudBackup',
                  hasArrow: true,
                  onTap: () => _triggerBackup(true),
                ),
                AdminSettingItem(
                  icon: Icons.sd_storage_outlined,
                  iconBgColor: const Color(0xFFAD46FF).withOpacity(0.2),
                  title: 'Local Backup',
                  subtitle: 'Last backup: $_lastLocalBackup',
                  hasArrow: true,
                  onTap: () => _triggerBackup(false),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AdminSection(
              title: 'AUTOMATIC BACKUP',
              children: [
                AdminSettingItem(
                  icon: Icons.auto_mode_outlined,
                  iconBgColor: const Color(0xFF00C950).withOpacity(0.2),
                  title: 'Daily Backup',
                  subtitle: _dailyBackup ? 'Enabled' : 'Disabled',
                  trailing: _buildSwitch(
                    _dailyBackup,
                    (val) => setState(() {
                      _dailyBackup = val;
                      Get.snackbar(
                        'Settings Updated',
                        'Daily automatic backup ${val ? "enabled" : "disabled"}',
                        backgroundColor: Colors.green[800],
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                      );
                    }),
                  ),
                ),
                AdminSettingItem(
                  icon: Icons.history_outlined,
                  iconBgColor: const Color(0xFFF0B100).withOpacity(0.2),
                  title: 'Retention Period',
                  subtitle: '$_retentionDays days',
                  hasArrow: true,
                  onTap: () => _showRetentionDialog(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF121212),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Select Backup Type',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF2B7FFF)),
                            title: const Text('Cloud Backup', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Get.back();
                              _triggerBackup(true);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.sd_storage_outlined, color: Color(0xFFAD46FF)),
                            title: const Text('Local Backup', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Get.back();
                              _triggerBackup(false);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC97777),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Create New Backup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFC97777),
      ),
    );
  }
}
