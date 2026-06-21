import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/features/hospital_inventory/domain/entities/hospital_entity.dart';
import 'package:flutter/material.dart';

/// Card for a single active blood request/proposal, with a
/// "View Details" action and a relative time label.
class ProposalCard extends StatelessWidget {
  const ProposalCard({super.key, required this.proposal, this.onViewDetails});

  final BloodRequestEntity proposal;
  final VoidCallback? onViewDetails;

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(proposal.title, style: const TextStyle(color: AppColors.text, fontSize: 13)),
                const SizedBox(height: 2),
                Text(_timeAgo(proposal.createdAt), style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          TextButton(
            onPressed: onViewDetails,
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }
}
