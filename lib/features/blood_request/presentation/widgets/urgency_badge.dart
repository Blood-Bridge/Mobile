import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/blood_request/domain/entities/blood_request_entity.dart';
import 'package:flutter/material.dart';

/// Small colored pill showing the request's urgency level
/// (Critical / Urgent / Normal).
class UrgencyBadge extends StatelessWidget {
  const UrgencyBadge({super.key, required this.urgency});

  final RequestUrgency urgency;

  Color get _color {
    switch (urgency) {
      case RequestUrgency.critical:
        return AppColors.destructive;
      case RequestUrgency.urgent:
        return const Color(0xFFE0B84A);
      case RequestUrgency.normal:
        return AppColors.textMuted;
    }
  }

  String get _label {
    switch (urgency) {
      case RequestUrgency.critical:
        return 'Critical';
      case RequestUrgency.urgent:
        return 'Urgent';
      case RequestUrgency.normal:
        return 'Normal';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color),
      ),
      child: Text(
        _label,
        style: TextStyle(color: _color, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}
