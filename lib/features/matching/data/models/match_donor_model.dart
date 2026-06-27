import 'package:blood_bridge/core/models/user_profile.dart';

class MatchDonorModel {
  final int userId;
  final String name;
  final double matchScore;
  final double distanceKm;
  final String? bloodType;
  final int? donationCount;
  final String? phonNumber;

  MatchDonorModel({
    required this.userId,
    required this.name,
    required this.matchScore,
    required this.distanceKm,
    this.bloodType,
    this.donationCount,
    this.phonNumber,
  });

  factory MatchDonorModel.fromJson(Map<String, dynamic> json) {
    return MatchDonorModel(
      userId: _toInt(json['userId']) ?? 0,
      name: json['name']?.toString() ?? 'Unknown Donor',
      matchScore: _toDouble(json['matchScore']) ?? 0.0,
      distanceKm: _toDouble(json['distanceKm']) ?? 0.0,
      bloodType: json['bloodType']?.toString(),
      donationCount: _toInt(json['donationCount']),
      phonNumber: json['phonNumber']?.toString(),
    );
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
