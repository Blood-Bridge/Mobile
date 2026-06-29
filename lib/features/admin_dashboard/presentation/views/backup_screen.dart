import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/admin_section.dart';
import 'widgets/admin_setting_item.dart';

class BackupScreen extends StatefulWidget {
  BackupScreen({super.key});

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
      Center(child: CircularProgressIndicator(color: Color(0xFFC97777))),
      barrierDismissible: false,
    );

    await Future.delayed(Duration(seconds: 2));
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
      margin: EdgeInsets.all(16),
    );
  }

  void _showRetentionDialog() {
    Get.dialog(
      SimpleDialog(
        backgroundColor: Color(0xFF121212),
        title: Text(
          AppLocalizations.of(context)!.retentionPeriod,
          style: TextStyle(color: Colors.white),
        ),
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
                margin: EdgeInsets.all(16),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '$days days',
                style: TextStyle(color: Colors.white, fontSize: 16),
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
      backgroundColor: Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppLocalizations.of(context)!.backupDatabase,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.5),
          child: Container(color: Color(0xFF262626), height: 1.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSection(
              title: AppLocalizations.of(context)!.backupOptions,
              children: [
                AdminSettingItem(
                  icon: Icons.cloud_upload_outlined,
                  iconBgColor: Color(0xFF2B7FFF).withOpacity(0.2),
                  title: AppLocalizations.of(context)!.backupToCloud,
                  subtitle: 'Last backup: $_lastCloudBackup',
                  hasArrow: true,
                  onTap: () => _triggerBackup(true),
                ),
                AdminSettingItem(
                  icon: Icons.sd_storage_outlined,
                  iconBgColor: Color(0xFFAD46FF).withOpacity(0.2),
                  title: AppLocalizations.of(context)!.localBackup,
                  subtitle: 'Last backup: $_lastLocalBackup',
                  hasArrow: true,
                  onTap: () => _triggerBackup(false),
                ),
              ],
            ),
            SizedBox(height: 24),
            AdminSection(
              title: AppLocalizations.of(context)!.automaticBackup,
              children: [
                AdminSettingItem(
                  icon: Icons.auto_mode_outlined,
                  iconBgColor: Color(0xFF00C950).withOpacity(0.2),
                  title: AppLocalizations.of(context)!.dailyBackup,
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
                        margin: EdgeInsets.all(16),
                      );
                    }),
                  ),
                ),
                AdminSettingItem(
                  icon: Icons.history_outlined,
                  iconBgColor: Color(0xFFF0B100).withOpacity(0.2),
                  title: AppLocalizations.of(context)!.retentionPeriod,
                  subtitle: '$_retentionDays days',
                  hasArrow: true,
                  onTap: () => _showRetentionDialog(),
                ),
              ],
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFF121212),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.selectBackupType,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          ListTile(
                            leading: Icon(
                              Icons.cloud_upload_outlined,
                              color: Color(0xFF2B7FFF),
                            ),
                            title: Text(
                              AppLocalizations.of(context)!.cloudBackup,
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Get.back();
                              _triggerBackup(true);
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.sd_storage_outlined,
                              color: Color(0xFFAD46FF),
                            ),
                            title: Text(
                              AppLocalizations.of(context)!.localBackup,
                              style: TextStyle(color: Colors.white),
                            ),
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
                  backgroundColor: Color(0xFFC97777),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.createNewBackup,
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
        activeColor: Color(0xFFC97777),
      ),
    );
  }
}
