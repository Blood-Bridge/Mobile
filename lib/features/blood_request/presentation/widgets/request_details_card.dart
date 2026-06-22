import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/blood_request/domain/entities/blood_request_entity.dart';
import 'package:flutter/material.dart';

/// "Request Details" card listing blood type, quantity, urgency,
/// and location as labeled rows.
class RequestDetailsCard extends StatelessWidget {
  const RequestDetailsCard({super.key, required this.request});

  final BloodRequestEntity request;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Request Details',
            style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _DetailRow(label: 'Blood Type', value: '${request.bloodType} (Positive)'),
          _DetailRow(label: 'Quantity', value: '${request.quantityUnits} Units'),
          _DetailRow(label: 'Urgency', value: _urgencyLabel(request.urgency)),
          _DetailRow(label: 'Location', value: request.location, isLast: true),
        ],
      ),
    );
  }

  String _urgencyLabel(RequestUrgency urgency) {
    switch (urgency) {
      case RequestUrgency.critical:
        return 'Critical';
      case RequestUrgency.urgent:
        return 'Urgent';
      case RequestUrgency.normal:
        return 'Normal';
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.isLast = false});

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          Text(value, style: const TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
