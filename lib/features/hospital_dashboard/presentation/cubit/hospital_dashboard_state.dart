part of 'hospital_dashboard_cubit.dart';

// ─────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────

class BloodInventoryItem {
  final String key;       // e.g. "OPositive"
  final String label;     // e.g. "O+"
  final int units;
  final String? status;   // "Normal" | "Low Stock" | "Critical"
  final String trend;     // "up" | "down" | "flat"

  const BloodInventoryItem({
    required this.key,
    required this.label,
    required this.units,
    this.status,
    this.trend = 'flat',
  });

  static String _computeStatus(int units) {
    if (units <= 10) return 'Critical';
    if (units <= 20) return 'Low Stock';
    return 'Normal';
  }

  factory BloodInventoryItem.fromMap(Map<String, dynamic> map) {
    const labelMap = {
      'OPositive': 'O+',
      'ONegative': 'O−',
      'APositive': 'A+',
      'ANegative': 'A−',
      'BPositive': 'B+',
      'BNegative': 'B−',
      'ABPositive': 'AB+',
      'ABNegative': 'AB−',
    };
    final key = map['bloodType'] as String? ?? '';
    final units = _toInt(map['unitsAvailable'] ?? map['units']);
    return BloodInventoryItem(
      key: key,
      label: labelMap[key] ?? key,
      units: units,
      status: _computeStatus(units),
    );
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}

class ActiveRequest {
  final String id;
  final String bloodType;
  final String urgency;   // "Critical" | "Urgent" | "Normal"
  final String timeAgo;
  final int donorCount;

  const ActiveRequest({
    required this.id,
    required this.bloodType,
    required this.urgency,
    required this.timeAgo,
    required this.donorCount,
  });

  factory ActiveRequest.fromMap(Map<String, dynamic> map) {
    return ActiveRequest(
      id: map['id']?.toString() ?? '',
      bloodType: _formatBloodType(map['bloodType']?.toString() ?? ''),
      urgency: _formatUrgency(map['urgencyLevel']?.toString() ?? map['urgency']?.toString() ?? 'Normal'),
      timeAgo: _formatTime(map['createdAt']?.toString() ?? map['requestDate']?.toString()),
      donorCount: _toInt(map['matchedDonors'] ?? map['donorCount'] ?? map['donors']),
    );
  }

  static String _formatBloodType(String raw) {
    const map = {
      'OPositive': 'O+', 'ONegative': 'O−',
      'APositive': 'A+', 'ANegative': 'A−',
      'BPositive': 'B+', 'BNegative': 'B−',
      'ABPositive': 'AB+', 'ABNegative': 'AB−',
    };
    return map[raw] ?? raw;
  }

  static String _formatUrgency(String raw) {
    switch (raw.toLowerCase()) {
      case 'critical': return 'Critical';
      case 'urgent':   return 'Urgent';
      default:         return 'Normal';
    }
  }

  static String _formatTime(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } catch (_) {
      return '';
    }
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}

class NearbyDonor {
  final String id;
  final String firstName;
  final String lastName;
  final String bloodType;
  final double distanceKm;
  final String phoneNumber;
  final double? latitude;
  final double? longitude;

  const NearbyDonor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.bloodType,
    required this.distanceKm,
    required this.phoneNumber,
    this.latitude,
    this.longitude,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory NearbyDonor.fromMap(Map<String, dynamic> map) {
    const btMap = {
      'OPositive': 'O+', 'ONegative': 'O−',
      'APositive': 'A+', 'ANegative': 'A−',
      'BPositive': 'B+', 'BNegative': 'B−',
      'ABPositive': 'AB+', 'ABNegative': 'AB−',
    };
    final rawBt = map['bloodType']?.toString() ?? '';
    return NearbyDonor(
      id: map['donorId']?.toString() ?? map['id']?.toString() ?? '',
      firstName: map['firstName']?.toString() ?? '',
      lastName: map['lastName']?.toString() ?? '',
      bloodType: btMap[rawBt] ?? rawBt,
      distanceKm: _toDouble(map['distanceKm'] ?? map['distance']),
      phoneNumber: map['phoneNumber']?.toString() ?? '',
      latitude: _toDouble(map['latitude']),
      longitude: _toDouble(map['longitude']),
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }
}

// ─────────────────────────────────────────────
// State
// ─────────────────────────────────────────────
class HospitalDashboardState {
  final bool isLoading;
  final String? error;
  final int availableBloodUnits;
  final int pendingRequests;
  final int activeDonors;
  final List<BloodInventoryItem> bloodInventory;
  final List<ActiveRequest> activeRequests;
  final List<NearbyDonor> nearbyDonors;

  const HospitalDashboardState({
    this.isLoading = false,
    this.error,
    this.availableBloodUnits = 0,
    this.pendingRequests = 0,
    this.activeDonors = 0,
    this.bloodInventory = const [],
    this.activeRequests = const [],
    this.nearbyDonors = const [],
  });

  factory HospitalDashboardState.initial() => const HospitalDashboardState();

  HospitalDashboardState copyWith({
    bool? isLoading,
    String? error,
    int? availableBloodUnits,
    int? pendingRequests,
    int? activeDonors,
    List<BloodInventoryItem>? bloodInventory,
    List<ActiveRequest>? activeRequests,
    List<NearbyDonor>? nearbyDonors,
  }) {
    return HospitalDashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      availableBloodUnits: availableBloodUnits ?? this.availableBloodUnits,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      activeDonors: activeDonors ?? this.activeDonors,
      bloodInventory: bloodInventory ?? this.bloodInventory,
      activeRequests: activeRequests ?? this.activeRequests,
      nearbyDonors: nearbyDonors ?? this.nearbyDonors,
    );
  }
}
