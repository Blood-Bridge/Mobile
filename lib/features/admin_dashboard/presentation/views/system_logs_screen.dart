import 'package:blood_bridge/core/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'widgets/admin_section.dart';

class SystemLogsScreen extends StatelessWidget {
  SystemLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        title: Text(
          context.l10n.systemLogs,
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
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildLogItem(
            context,
            type: index % 3 == 0
                ? 'ERROR'
                : (index % 2 == 0 ? 'INFO' : 'WARNING'),
            message: 'System activity log message example #$index',
            time: '${index + 1} hours ago',
          );
        },
      ),
    );
  }

  Widget _buildLogItem(
    BuildContext context, {
    required String type,
    required String message,
    required String time,
  }) {
    Color typeColor;
    switch (type) {
      case 'ERROR':
        typeColor = Color(0xFFFB2C36);
        break;
      case 'WARNING':
        typeColor = Color(0xFFF0B100);
        break;
      default:
        typeColor = Color(0xFF2B7FFF);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF262626), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(color: Color(0xFF99A1AF), fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(message, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
