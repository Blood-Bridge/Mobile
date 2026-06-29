import 'package:blood_bridge/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'widgets/admin_section.dart';
import 'widgets/admin_setting_item.dart';

class LanguageSettingsScreen extends StatelessWidget {
  LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.systemLanguage,
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
              title: AppLocalizations.of(context)!.selectLanguage,
              children: [
                _buildLanguageItem(context, 'English', 'United States', true),
                _buildLanguageItem(context, 'Arabic', 'Saudi Arabia', false),
                _buildLanguageItem(context, 'French', 'France', false),
                _buildLanguageItem(context, 'Spanish', 'Spain', false),
              ],
            ),
            SizedBox(height: 24),
            AdminSection(
              title: 'LOCALIZATION',
              children: [
                AdminSettingItem(
                  icon: Icons.date_range_outlined,
                  iconBgColor: Color(0xFF2B7FFF).withOpacity(0.2),
                  title: AppLocalizations.of(context)!.dateFormat,
                  subtitle: 'MM/DD/YYYY',
                  hasArrow: true,
                ),
                AdminSettingItem(
                  icon: Icons.access_time_outlined,
                  iconBgColor: Color(0xFFAD46FF).withOpacity(0.2),
                  title: AppLocalizations.of(context)!.timeFormat,
                  subtitle: '24-hour',
                  hasArrow: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    String language,
    String region,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    region,
                    style: TextStyle(
                      color: Color(0xFF99A1AF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Color(0xFF00C950), size: 24),
          ],
        ),
      ),
    );
  }
}
