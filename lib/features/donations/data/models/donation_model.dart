class DonationModel {
  final int donationProcessId;
  final int donorId;
  final int bloodRequestId;
  final int hospitalId;
  final DateTime donationDate;
  final String confirmationStatus;
  final DateTime createdAt;

  const DonationModel({
    required this.donationProcessId,
    required this.donorId,
    required this.bloodRequestId,
    required this.hospitalId,
    required this.donationDate,
    required this.confirmationStatus,
    required this.createdAt,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      donationProcessId: json['donationProcessId'] as int? ?? 0,
      donorId: json['donorId'] as int? ?? 0,
      bloodRequestId: json['bloodRequestId'] as int? ?? 0,
      hospitalId: json['hospitalId'] as int? ?? 0,
      donationDate: json['donationDate'] != null
          ? DateTime.tryParse(json['donationDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      confirmationStatus: json['confirmationStatus'] as String? ?? 'Pending',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donationProcessId': donationProcessId,
      'donorId': donorId,
      'bloodRequestId': bloodRequestId,
      'hospitalId': hospitalId,
      'donationDate': donationDate.toIso8601String(),
      'confirmationStatus': confirmationStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
