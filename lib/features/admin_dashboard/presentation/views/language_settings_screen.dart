import 'package:flutter/material.dart';
import 'widgets/admin_section.dart';
import 'widgets/admin_setting_item.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        title: const Text(
          'System Language',
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
              title: 'SELECT LANGUAGE',
              children: [
                _buildLanguageItem(context, 'English', 'United States', true),
                _buildLanguageItem(context, 'Arabic', 'Saudi Arabia', false),
                _buildLanguageItem(context, 'French', 'France', false),
                _buildLanguageItem(context, 'Spanish', 'Spain', false),
              ],
            ),
            const SizedBox(height: 24),
            AdminSection(
              title: 'LOCALIZATION',
              children: [
                AdminSettingItem(
                  icon: Icons.date_range_outlined,
                  iconBgColor: const Color(0xFF2B7FFF).withOpacity(0.2),
                  title: 'Date Format',
                  subtitle: 'MM/DD/YYYY',
                  hasArrow: true,
                ),
                AdminSettingItem(
                  icon: Icons.access_time_outlined,
                  iconBgColor: const Color(0xFFAD46FF).withOpacity(0.2),
                  title: 'Time Format',
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

  Widget _buildLanguageItem(BuildContext context, String language, String region, bool isSelected) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    region,
                    style: const TextStyle(color: Color(0xFF99A1AF), fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF00C950), size: 24),
          ],
        ),
      ),
    );
  }
}
