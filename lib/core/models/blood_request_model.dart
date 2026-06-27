/// Represents a blood request item returned by GET /api/Requests/active
/// and GET /api/Requests/history.
class BloodRequestModel {
  final int requestId;
  final DateTime createdAt;
  final String status;
  final String bloodType;
  final int quantity;
  final int hospitalId;

  const BloodRequestModel({
    required this.requestId,
    required this.createdAt,
    required this.status,
    required this.bloodType,
    required this.quantity,
    required this.hospitalId,
  });

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
    return BloodRequestModel(
      requestId: json['requestId'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as String? ?? 'Unknown',
      bloodType: json['bloodType'] as String? ?? '--',
      quantity: json['quantity'] as int? ?? 0,
      hospitalId: json['hospitalId'] as int? ?? 0,
    );
  }

  /// Human-readable blood type (e.g. "OPositive" → "O+")
  String get bloodTypeDisplay {
    const map = {
      'OPositive': 'O+',
      'ONegative': 'O-',
      'APositive': 'A+',
      'ANegative': 'A-',
      'BPositive': 'B+',
      'BNegative': 'B-',
      'ABPositive': 'AB+',
      'ABNegative': 'AB-',
    };
    return map[bloodType] ?? bloodType;
  }

  /// Returns a relative time string like "4 h", "2 d", "just now"
  String get relativeTime {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min';
    if (diff.inDays < 1) return '${diff.inHours} h';
    return '${diff.inDays} d';
  }

  BloodRequestModel copyWith({String? status}) {
    return BloodRequestModel(
      requestId: requestId,
      createdAt: createdAt,
      status: status ?? this.status,
      bloodType: bloodType,
      quantity: quantity,
      hospitalId: hospitalId,
    );
  }
}
