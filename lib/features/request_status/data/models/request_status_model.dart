import 'package:flutter/foundation.dart';

class RequestStatusModel {
  final String status;

  const RequestStatusModel({required this.status});

  factory RequestStatusModel.fromJson(Map<String, dynamic> json) {
    String status = 'Pending';

    final data = json['data'];

    if (data is Map<String, dynamic>) {
      status = (data['status'] as String?)?.trim() ?? 'Pending';
    } else if (json['status'] is String) {
      status = (json['status'] as String).trim();
    } else if (data is String) {
      status = data.trim();
    }

    debugPrint('📌 Parsed Status from JSON: "$status"'); // مهم للتصحيح

    return RequestStatusModel(status: status);
  }

  static const List<String> statusTimeline = [
    'Pending',
    'Analyzing',
    'Open',
    'Accepted',
    'Completed',
  ];

  int get currentIndex {
    final idx = statusTimeline.indexOf(status);
    return idx != -1 ? idx : 0;
  }

  bool isStepCompleted(String step) {
    final stepIdx = statusTimeline.indexOf(step);
    if (stepIdx == -1) return false;
    return stepIdx < currentIndex;
  }

  bool isStepActive(String step) {
    return status.toLowerCase() == step.toLowerCase();
  }
}
